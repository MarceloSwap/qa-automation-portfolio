*** Settings ***
Documentation    Testes de Gerenciamento de Usuários (Admin) - Papéis de Usuário
Resource         ../resources/base.resource
Resource         ../resources/keywords/auth_keywords.resource
Resource         ../resources/keywords/user_keywords.resource
Suite Setup      Setup User Management Tests
Suite Teardown   Teardown Test Session
Test Tags        users    admin    management

*** Variables ***
${ADMIN_TOKEN}    ${EMPTY}
${USER_TOKEN}     ${EMPTY}
${TEST_USER_ID}   ${EMPTY}

*** Test Cases ***
# Testes básicos de acesso negado para funcionalidades de admin
Test Get All Users Without Admin Token
    [Documentation]    Testa obtenção de usuários sem token admin
    [Tags]    users    list    negative
    Skip If    '${USER_TOKEN}' == '${EMPTY}'    Token usuário não disponível
    
    ${response}=    Get All Users    ${USER_TOKEN}
    Should Be Equal As Integers    ${response.status_code}    403

Test Get All Users Without Authentication
    [Documentation]    Testa obtenção de usuários sem autenticação
    [Tags]    users    list    negative
    ${response}=    GET On Session    ${SESSION}    /users
    ...    headers=${HEADERS}
    ...    expected_status=any
    Should Be Equal As Integers    ${response.status_code}    401

Test Get User Without Admin Token
    [Documentation]    Testa obtenção de usuário sem token admin
    [Tags]    users    details    negative
    Skip If    '${USER_TOKEN}' == '${EMPTY}'    Token usuário não disponível
    
    ${response}=    Get User By ID    ${USER_TOKEN}    507f1f77bcf86cd799439011
    Should Be Equal As Integers    ${response.status_code}    403

Test Update User Without Admin Token
    [Documentation]    Testa atualização de usuário sem token admin
    [Tags]    users    update    negative
    Skip If    '${USER_TOKEN}' == '${EMPTY}'    Token usuário não disponível
    
    &{update_data}=    Create Dictionary    name=Novo Nome
    ${response}=    Update User    ${USER_TOKEN}    507f1f77bcf86cd799439011    ${update_data}
    Should Be Equal As Integers    ${response.status_code}    403

Test Delete User Without Admin Token
    [Documentation]    Testa remoção de usuário sem token admin
    [Tags]    users    delete    negative
    Skip If    '${USER_TOKEN}' == '${EMPTY}'    Token usuário não disponível
    
    ${response}=    Delete User    ${USER_TOKEN}    507f1f77bcf86cd799439011
    Should Be Equal As Integers    ${response.status_code}    403

Test Regular User Cannot Access User Management
    [Documentation]    Testa que usuário comum não pode acessar gerenciamento
    [Tags]    users    roles    user    negative
    Skip If    '${USER_TOKEN}' == '${EMPTY}'    Token usuário não disponível
    
    # Tenta listar usuários
    ${list_response}=    Get All Users    ${USER_TOKEN}
    Should Be Equal As Integers    ${list_response.status_code}    403
    
    # Tenta obter usuário por ID
    ${get_response}=    Get User By ID    ${USER_TOKEN}    507f1f77bcf86cd799439011
    Should Be Equal As Integers    ${get_response.status_code}    403
    
    # Tenta atualizar usuário
    &{update_data}=    Create Dictionary    name=Teste
    ${update_response}=    Update User    ${USER_TOKEN}    507f1f77bcf86cd799439011    ${update_data}
    Should Be Equal As Integers    ${update_response.status_code}    403
    
    # Tenta deletar usuário
    ${delete_response}=    Delete User    ${USER_TOKEN}    507f1f77bcf86cd799439011
    Should Be Equal As Integers    ${delete_response.status_code}    403

*** Keywords ***
Setup User Management Tests
    [Documentation]    Configura dados para testes de gerenciamento de usuários
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
        
        # Obtém ID do usuário criado
        ${user_id}=    Get Value From Json    ${user_response.json()}    $.data._id
        ${user_id}=    Get From List    ${user_id}    0
        Set Suite Variable    ${TEST_USER_ID}    ${user_id}
    END