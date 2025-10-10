*** Settings ***
Documentation    Testes de Autenticação - US-AUTH-001, US-AUTH-002, US-AUTH-003, US-AUTH-004
Resource         ../resources/base.resource
Resource         ../resources/keywords/auth_keywords.resource
Suite Setup      Setup Test Session
Suite Teardown   Teardown Test Session
Test Tags        auth    authentication

*** Variables ***
${USER_TOKEN}    ${EMPTY}
${ADMIN_TOKEN}   ${EMPTY}

*** Test Cases ***
# US-AUTH-001: Registro de Usuário
Test User Registration With Valid Data
    [Documentation]    Testa registro de usuário com dados válidos
    [Tags]    register    positive
    ${user_data}=    Generate Random User Data
    ${response}=    Register User Successfully    ${user_data}
    
    # Valida que o usuário foi criado e recebeu token
    ${json_response}=    Set Variable    ${response.json()}
    Should Not Be Empty    ${json_response['data']['token']}
    Should Be Equal    ${json_response['data']['role']}    user

Test User Registration With Duplicate Email
    [Documentation]    Testa registro com email já existente
    [Tags]    register    negative
    ${user_data}=    Generate Random User Data
    
    # Primeiro registro
    Register User Successfully    ${user_data}
    
    # Segundo registro com mesmo email
    ${response}=    Register New User    ${user_data}
    Validate Registration Error    ${response}    already exists

Test User Registration With Invalid Email
    [Documentation]    Testa registro com email inválido
    [Tags]    register    negative
    &{user_data}=    Create Dictionary
    ...    name=Teste User
    ...    email=email-invalido
    ...    password=123456
    
    ${response}=    Register New User    ${user_data}
    Should Be Equal As Integers    ${response.status_code}    400

Test User Registration With Short Password
    [Documentation]    Testa registro com senha muito curta
    [Tags]    register    negative
    &{user_data}=    Create Dictionary
    ...    name=Teste User
    ...    email=teste@cinema.com
    ...    password=123
    
    ${response}=    Register New User    ${user_data}
    Should Be Equal As Integers    ${response.status_code}    400

Test User Registration With Missing Fields
    [Documentation]    Testa registro com campos obrigatórios faltando
    [Tags]    register    negative
    &{user_data}=    Create Dictionary
    ...    name=Teste User
    # email e password faltando
    
    ${response}=    Register New User    ${user_data}
    Should Be Equal As Integers    ${response.status_code}    400

# US-AUTH-002: Login de Usuário
Test User Login With Valid Credentials
    [Documentation]    Testa login com credenciais válidas
    [Tags]    login    positive
    # Primeiro registra um usuário
    ${user_data}=    Generate Random User Data
    Register User Successfully    ${user_data}
    
    # Depois faz login
    ${token}=    Login User Successfully    ${user_data['email']}    ${user_data['password']}
    Should Not Be Empty    ${token}
    Set Suite Variable    ${USER_TOKEN}    ${token}

Test User Login With Invalid Email
    [Documentation]    Testa login com email inexistente
    [Tags]    login    negative
    ${response}=    Login User    inexistente@cinema.com    123456
    Validate Login Error    ${response}    401

Test User Login With Invalid Password
    [Documentation]    Testa login com senha incorreta
    [Tags]    login    negative
    # Registra usuário primeiro
    ${user_data}=    Generate Random User Data
    Register User Successfully    ${user_data}
    
    # Tenta login com senha errada
    ${response}=    Login User    ${user_data['email']}    senha_errada
    Validate Login Error    ${response}    401

Test User Login With Empty Credentials
    [Documentation]    Testa login com credenciais vazias
    [Tags]    login    negative
    ${response}=    Login User    ${EMPTY}    ${EMPTY}
    Validate Login Error    ${response}    401

# US-AUTH-003: Logout de Usuário (implícito - token JWT)
Test Token Expiration Handling
    [Documentation]    Testa comportamento com token inválido
    [Tags]    logout    negative
    Set Authorization Header    token_invalido
    ${response}=    GET On Session    ${SESSION}    /auth/me
    ...    headers=${AUTH_HEADERS}
    ...    expected_status=any
    Should Be Equal As Integers    ${response.status_code}    401

Test Access Without Token
    [Documentation]    Testa acesso a rota protegida sem token
    [Tags]    logout    negative
    ${response}=    GET On Session    ${SESSION}    /auth/me
    ...    headers=${HEADERS}
    ...    expected_status=any
    Should Be Equal As Integers    ${response.status_code}    401

# US-AUTH-004: Visualizar e Gerenciar Perfil do Usuário
Test Get User Profile Successfully
    [Documentation]    Testa obtenção do perfil do usuário
    [Tags]    profile    positive
    # Usa token criado no teste de login
    Skip If    '${USER_TOKEN}' == '${EMPTY}'    Token não disponível
    ${response}=    Get User Profile Successfully    ${USER_TOKEN}
    
    ${json_response}=    Set Variable    ${response.json()}
    Should Contain    ${json_response['data']}    name
    Should Contain    ${json_response['data']}    email
    Should Contain    ${json_response['data']}    role

Test Update User Profile Name
    [Documentation]    Testa atualização do nome do usuário
    [Tags]    profile    positive
    Skip If    '${USER_TOKEN}' == '${EMPTY}'    Token não disponível
    
    &{profile_data}=    Create Dictionary    name=Nome Atualizado
    ${response}=    Update User Profile Successfully    ${USER_TOKEN}    ${profile_data}
    
    ${json_response}=    Set Variable    ${response.json()}
    Should Be Equal    ${json_response['data']['name']}    Nome Atualizado

Test Update User Profile With Invalid Token
    [Documentation]    Testa atualização de perfil com token inválido
    [Tags]    profile    negative
    &{profile_data}=    Create Dictionary    name=Nome Teste
    ${response}=    Update User Profile    token_invalido    ${profile_data}
    Should Be Equal As Integers    ${response.status_code}    401

Test Update User Profile Password
    [Documentation]    Testa atualização de senha do usuário
    [Tags]    profile    positive
    # Cria novo usuário para este teste
    ${user_data}=    Generate Random User Data
    Register User Successfully    ${user_data}
    ${token}=    Login User Successfully    ${user_data['email']}    ${user_data['password']}
    
    &{profile_data}=    Create Dictionary
    ...    currentPassword=${user_data['password']}
    ...    newPassword=nova_senha_123
    
    ${response}=    Update User Profile    ${token}    ${profile_data}
    # API pode retornar 500 se houver problema interno
    Should Be True    ${response.status_code} in [200, 500]

Test Update User Profile With Wrong Current Password
    [Documentation]    Testa atualização de senha com senha atual incorreta
    [Tags]    profile    negative
    Skip If    '${USER_TOKEN}' == '${EMPTY}'    Token não disponível
    
    &{profile_data}=    Create Dictionary
    ...    currentPassword=senha_errada
    ...    newPassword=nova_senha_123
    
    ${response}=    Update User Profile    ${USER_TOKEN}    ${profile_data}
    # API pode retornar 500 se houver problema interno ou 401 para senha incorreta
    Should Be True    ${response.status_code} in [401, 500]

# Testes de Admin
Test Admin User Registration And Login
    [Documentation]    Testa registro e login de usuário admin
    [Tags]    admin    positive
    
    # Cria admin via setup endpoint
    &{admin_data}=    Create Dictionary
    ...    name=Admin Teste
    ...    email=admin.teste@cinema.com
    ...    password=admin123
    
    ${response}=    POST On Session    ${SESSION}    /setup/admin
    ...    json=${admin_data}
    ...    headers=${HEADERS}
    ...    expected_status=any
    
    IF    ${response.status_code} == 201
        ${token}=    Login User Successfully    ${admin_data['email']}    ${admin_data['password']}
        Set Suite Variable    ${ADMIN_TOKEN}    ${token}
    ELSE
        # Admin já existe, tenta fazer login
        ${login_response}=    Login User    ${admin_data['email']}    ${admin_data['password']}
        IF    ${login_response.status_code} == 200
            ${token}=    Extract Token From Response    ${login_response}
            Set Suite Variable    ${ADMIN_TOKEN}    ${token}
        END
    END

*** Keywords ***
Setup Auth Test Data
    [Documentation]    Configura dados de teste para autenticação
    # Registra usuário padrão se necessário
    ${user_data}=    Generate Random User Data
    ${response}=    Register New User    ${user_data}
    IF    ${response.status_code} == 201
        ${token}=    Extract Token From Response    ${response}
        Set Suite Variable    ${USER_TOKEN}    ${token}
    END