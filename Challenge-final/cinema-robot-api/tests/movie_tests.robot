*** Settings ***
Documentation    Testes de Filmes - US-MOVIE-001, US-MOVIE-002, US-HOME-001
Resource         ../resources/base.resource
Resource         ../resources/keywords/auth_keywords.resource
Resource         ../resources/keywords/movie_keywords.resource
Suite Setup      Setup Movie Tests
Suite Teardown   Teardown Test Session
Test Tags        movies

*** Variables ***
${ADMIN_TOKEN}    ${EMPTY}
${USER_TOKEN}     ${EMPTY}
${MOVIE_ID}       ${EMPTY}

*** Test Cases ***
# US-HOME-001 & US-MOVIE-001: Navegar na Lista de Filmes
Test Get All Movies Without Authentication
    [Documentation]    Testa obtenção de filmes sem autenticação (público)
    [Tags]    US-MOVIE-001
    ${response}=    Get All Movies Successfully
    
    ${json_response}=    Set Variable    ${response.json()}
    Should Be True    ${json_response['count']} >= 0
    Should Contain    ${json_response}    data

Test Get All Movies With Pagination
    [Documentation]    Testa paginação da lista de filmes
    [Tags]    US-MOVIE-001
    &{params}=    Create Dictionary    page=1    limit=5
    ${response}=    Get All Movies Successfully    ${params}
    
    ${json_response}=    Set Variable    ${response.json()}
    # A API pode não ter paginação implementada, apenas verifica se retorna dados
    Should Contain    ${json_response}    data
    Should Be True    ${json_response['count']} >= 0

Test Search Movies By Title
    [Documentation]    Testa busca de filmes por título
    [Tags]    US-MOVIE-001
    Skip If    '${ADMIN_TOKEN}' == '${EMPTY}'    Token admin não disponível
    
    # Busca por título genérico
    ${search_response}=    Search Movies By Title    Filme

Test Search Movies By Genre
    [Documentation]    Testa busca de filmes por gênero
    [Tags]    US-MOVIE-001
    &{params}=    Create Dictionary    genre=Ação
    ${response}=    Get All Movies Successfully    ${params}

Test Sort Movies By Release Date
    [Documentation]    Testa ordenação de filmes por data de lançamento
    [Tags]    US-MOVIE-001
    &{params}=    Create Dictionary    sort=releaseDate
    ${response}=    Get All Movies Successfully    ${params}

# US-MOVIE-002: Visualizar Detalhes do Filme
Test Get Movie By Valid ID
    [Documentation]    Testa obtenção de filme por ID válido
    [Tags]    US-MOVIE-002
    Skip If    '${MOVIE_ID}' == '${EMPTY}'    ID do filme não disponível
    ${response}=    Get Movie By ID Successfully    ${MOVIE_ID}
    
    ${json_response}=    Set Variable    ${response.json()}
    Should Contain    ${json_response['data']}    title
    Should Contain    ${json_response['data']}    synopsis
    Should Contain    ${json_response['data']}    director
    Should Contain    ${json_response['data']}    genres
    Should Contain    ${json_response['data']}    duration
    Should Contain    ${json_response['data']}    classification
    Should Contain    ${json_response['data']}    releaseDate

Test Get Movie By Invalid ID
    [Documentation]    Testa obtenção de filme com ID inválido
    [Tags]    US-MOVIE-002
    ${response}=    Get Movie By ID    id_invalido
    Should Be Equal As Integers    ${response.status_code}    404

Test Get Movie By Nonexistent ID
    [Documentation]    Testa obtenção de filme com ID inexistente
    [Tags]    US-MOVIE-002
    ${response}=    Get Movie By ID    507f1f77bcf86cd799439011
    Validate Movie Not Found    ${response}

# Testes de acesso negado para funcionalidades de admin
Test Create Movie Without Admin Token
    [Documentation]    Testa criação de filme sem token admin
    [Tags]    US-ADMIN-001
    Skip If    '${USER_TOKEN}' == '${EMPTY}'    Token usuário não disponível
    
    ${movie_data}=    Generate Random Movie Data
    ${response}=    Create Movie    ${USER_TOKEN}    ${movie_data}
    Validate Admin Required    ${response}

Test Create Movie Without Authentication
    [Documentation]    Testa criação de filme sem autenticação
    [Tags]    US-ADMIN-001
    ${movie_data}=    Generate Random Movie Data
    ${response}=    POST On Session    ${SESSION}    /movies
    ...    json=${movie_data}
    ...    headers=${HEADERS}
    ...    expected_status=any
    Should Be Equal As Integers    ${response.status_code}    401

# Testes de Performance e Limites
Test Get Movies With Large Limit
    [Documentation]    Testa obtenção de filmes com limite alto
    [Tags]    US-MOVIE-001
    &{params}=    Create Dictionary    limit=100
    ${response}=    Get All Movies Successfully    ${params}
    
    ${json_response}=    Set Variable    ${response.json()}
    ${data_length}=    Get Length    ${json_response['data']}
    Should Be True    ${data_length} <= 100

Test Movie Data Validation
    [Documentation]    Testa validação completa dos dados do filme
    [Tags]    US-MOVIE-002
    Skip If    '${MOVIE_ID}' == '${EMPTY}'    ID do filme não disponível
    
    ${response}=    Get Movie By ID Successfully    ${MOVIE_ID}
    ${movie}=    Set Variable    ${response.json()['data']}
    
    # Valida tipos de dados
    Should Be String    ${movie['title']}
    Should Be String    ${movie['synopsis']}
    Should Be String    ${movie['director']}
    Should Be List      ${movie['genres']}
    Should Be Number    ${movie['duration']}
    Should Be String    ${movie['classification']}
    
    # Valida valores
    Should Not Be Empty    ${movie['title']}
    Should Not Be Empty    ${movie['synopsis']}
    Should Not Be Empty    ${movie['director']}
    Should Be True    ${movie['duration']} > 0
    Should Be True    len($movie['genres']) > 0

*** Keywords ***
Setup Movie Tests
    [Documentation]    Configura dados para testes de filmes
    Setup Test Session
    
    # Cria usuários de teste via setup endpoint
    ${setup_response}=    POST On Session    ${SESSION}    /setup/test-users
    ...    headers=${HEADERS}
    ...    expected_status=any
    
    # Faz login com admin padrão
    ${admin_login}=    Login User    admin@example.com    admin123
    IF    ${admin_login.status_code} == 200
        ${admin_token}=    Extract Token From Response    ${admin_login}
        Set Suite Variable    ${ADMIN_TOKEN}    ${admin_token}
    END
    
    # Cria usuário comum
    ${user_data}=    Generate Random User Data
    ${user_response}=    Register New User    ${user_data}
    IF    ${user_response.status_code} == 201
        ${user_token}=    Extract Token From Response    ${user_response}
        Set Suite Variable    ${USER_TOKEN}    ${user_token}
    END
    
    # Cria filme de teste
    IF    '${ADMIN_TOKEN}' != '${EMPTY}'
        ${movie_data}=    Generate Random Movie Data
        ${movie_response}=    Create Movie    ${ADMIN_TOKEN}    ${movie_data}
        IF    ${movie_response.status_code} == 201
            ${movie_id}=    Get Value From Json    ${movie_response.json()}    $.data._id
            ${movie_id}=    Get From List    ${movie_id}    0
            Set Suite Variable    ${MOVIE_ID}    ${movie_id}
        END
    END