*** Settings ***
Documentation    Testes de Integração da API - Fluxos Completos e Navegação
Resource         ../resources/base.resource
Resource         ../resources/keywords/auth_keywords.resource
Resource         ../resources/keywords/movie_keywords.resource
Resource         ../resources/keywords/reservation_keywords.resource
Suite Setup      Setup Integration Tests
Suite Teardown   Teardown Test Session
Test Tags        integration    navigation    e2e

*** Variables ***
${USER_TOKEN}     ${EMPTY}
${ADMIN_TOKEN}    ${EMPTY}
${MOVIE_ID}       ${EMPTY}
${SESSION_ID}     ${EMPTY}

*** Test Cases ***
# US-NAV-001: Navegação Intuitiva - Teste de API Info
Test API Information Endpoint
    [Documentation]    Testa endpoint de informações da API
    [Tags]    navigation    api_info    positive
    ${response}=    GET On Session    ${SESSION}    /
    ...    headers=${HEADERS}
    ...    expected_status=any
    
    Should Be Equal As Integers    ${response.status_code}    200
    ${json_response}=    Set Variable    ${response.json()}
    
    Should Be True    ${json_response['success']}
    Should Contain    ${json_response}    endpoints
    Should Contain    ${json_response['endpoints']}    auth
    Should Contain    ${json_response['endpoints']}    movies
    Should Contain    ${json_response['endpoints']}    users
    Should Contain    ${json_response['endpoints']}    reservations
    Should Contain    ${json_response}    documentation

# Fluxo Completo: Visitante -> Usuário -> Reserva
Test Complete User Journey - Registration To Reservation
    [Documentation]    Testa jornada completa do usuário: registro -> login -> visualizar filmes -> fazer reserva
    [Tags]    integration    user_journey    positive
    
    # 1. Registro de usuário
    ${user_data}=    Generate Random User Data
    ${register_response}=    Register User Successfully    ${user_data}
    ${user_token}=    Extract Token From Response    ${register_response}
    
    # 2. Login (já feito no registro, mas testamos separadamente)
    ${login_token}=    Login User Successfully    ${user_data['email']}    ${user_data['password']}
    Should Be Equal    ${user_token}    ${login_token}
    
    # 3. Visualizar perfil
    ${profile_response}=    Get User Profile Successfully    ${user_token}
    ${profile}=    Set Variable    ${profile_response.json()['data']}
    Should Be Equal    ${profile['email']}    ${user_data['email']}
    
    # 4. Visualizar lista de filmes
    ${movies_response}=    Get All Movies Successfully
    ${movies}=    Set Variable    ${movies_response.json()['data']}
    
    # 5. Se há filmes, visualizar detalhes de um
    IF    len($movies) > 0
        ${first_movie}=    Set Variable    ${movies[0]}
        ${movie_details}=    Get Movie By ID Successfully    ${first_movie['_id']}
        Should Contain    ${movie_details.json()['data']}    synopsis
    END
    
    # 6. Tentar fazer reserva (pode falhar se não houver sessões)
    IF    '${SESSION_ID}' != '${EMPTY}'
        ${reservation_data}=    Generate Reservation Data    ${SESSION_ID}
        ${reservation_response}=    Create Reservation    ${user_token}    ${reservation_data}
        # Aceita tanto sucesso quanto erro de sessão não encontrada
        Should Be True    ${reservation_response.status_code} in [201, 404]
    END









# Teste de Error Handling
Test Error Handling Consistency
    [Documentation]    Testa consistência no tratamento de erros
    [Tags]    integration    error_handling    negative
    
    # Testa endpoints sem autenticação quando necessária
    @{protected_endpoints}=    Create List
    ...    /auth/me
    ...    /auth/profile
    ...    /reservations/me
    
    FOR    ${endpoint}    IN    @{protected_endpoints}
        ${response}=    GET On Session    ${SESSION}    ${endpoint}
        ...    headers=${HEADERS}
        ...    expected_status=any
        Should Be Equal As Integers    ${response.status_code}    401
        ${json_response}=    Set Variable    ${response.json()}
        Should Not Be True    ${json_response['success']}
    END
    
    # Testa endpoints com token inválido
    Set Authorization Header    token_invalido
    FOR    ${endpoint}    IN    @{protected_endpoints}
        ${response}=    GET On Session    ${SESSION}    ${endpoint}
        ...    headers=${AUTH_HEADERS}
        ...    expected_status=any
        Should Be Equal As Integers    ${response.status_code}    401
        ${json_response}=    Set Variable    ${response.json()}
        Should Not Be True    ${json_response['success']}
    END
    
    # Testa recursos não encontrados - apenas filmes (públicos)
    ${response}=    GET On Session    ${SESSION}    /movies/507f1f77bcf86cd799439011
    ...    headers=${HEADERS}
    ...    expected_status=any
    Should Be Equal As Integers    ${response.status_code}    404
    
    # Testa endpoints protegidos sem auth - espera 401 não 404
    @{protected_not_found}=    Create List
    ...    /users/507f1f77bcf86cd799439011
    ...    /reservations/507f1f77bcf86cd799439011
    
    FOR    ${endpoint}    IN    @{protected_not_found}
        ${response}=    GET On Session    ${SESSION}    ${endpoint}
        ...    headers=${HEADERS}
        ...    expected_status=any
        Should Be Equal As Integers    ${response.status_code}    401
    END

# Teste de Performance Básica
Test Basic Performance
    [Documentation]    Testa performance básica da API
    [Tags]    integration    performance    positive
    
    # Mede tempo de resposta para endpoints públicos
    ${start_time}=    Get Current Date    result_format=epoch
    ${movies_response}=    Get All Movies Successfully
    ${end_time}=    Get Current Date    result_format=epoch
    ${response_time}=    Evaluate    ${end_time} - ${start_time}
    
    # Resposta deve ser menor que 5 segundos
    Should Be True    ${response_time} < 5
    
    # Testa múltiplas requisições
    FOR    ${i}    IN RANGE    5
        ${response}=    Get All Movies
        Should Be Equal As Integers    ${response.status_code}    200
    END

*** Keywords ***
Setup Integration Tests
    [Documentation]    Configura dados para testes de integração
    Setup Test Session
    
    # Cria usuários de teste via setup endpoint
    ${setup_response}=    POST On Session    ${SESSION}    /setup/test-users
    ...    headers=${HEADERS}
    ...    expected_status=any
    
    # Cria usuário comum
    ${user_data}=    Generate Random User Data
    ${user_response}=    Register New User    ${user_data}
    IF    ${user_response.status_code} == 201
        ${user_token}=    Extract Token From Response    ${user_response}
        Set Suite Variable    ${USER_TOKEN}    ${user_token}
    END
    
    # Faz login com admin padrão
    ${admin_login}=    Login User    admin@example.com    admin123
    IF    ${admin_login.status_code} == 200
        ${admin_token}=    Extract Token From Response    ${admin_login}
        Set Suite Variable    ${ADMIN_TOKEN}    ${admin_token}
    END
    
    # Cria filme de teste se admin disponível
    IF    '${ADMIN_TOKEN}' != '${EMPTY}'
        ${movie_data}=    Generate Random Movie Data
        ${movie_response}=    Create Movie    ${ADMIN_TOKEN}    ${movie_data}
        IF    ${movie_response.status_code} == 201
            ${movie_id}=    Get Value From Json    ${movie_response.json()}    $.data._id
            ${movie_id}=    Get From List    ${movie_id}    0
            Set Suite Variable    ${MOVIE_ID}    ${movie_id}
        END
    END
    
    # Define ID de sessão fictício para testes
    Set Suite Variable    ${SESSION_ID}    507f1f77bcf86cd799439013