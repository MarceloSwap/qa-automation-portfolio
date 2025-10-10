*** Settings ***
Documentation       Testes de logout de usuário
...                 US-AUTH-003: Logout de Usuário

Resource          ../resources/base.resource

Test Setup        Start Session
Test Teardown     Take Screenshot

*** Test Cases ***
CT-Auth-011 Deve permitir logout através do menu
    [Documentation]    Verifica se usuário pode fazer logout através do menu de navegação
    [Tags]    auth    logout    positive
    
    ${user}    Create Dictionary
    ...    name=CT-Auth-011 Logout Menu
    ...    email=ct-auth-011@mail.com
    ...    password=pwd123

    Remove user from database       ${user}[email]
    Insert user from database       ${user}
    
    Go to login page
    Submit login form        ${user}
    User should be logged in    ${user}[name]
    
    Logout from application
    Confirme logout

CT-Auth-012 Deve tornar rotas protegidas inacessíveis após logout
    [Documentation]    Verifica se rotas protegidas não são acessíveis após logout
    [Tags]    auth    logout    security    positive
    
    ${user}    Create Dictionary
    ...    name=CT-Auth-012 Rotas Protegidas
    ...    email=ct-auth-012@mail.com
    ...    password=pwd123

    Remove user from database       ${user}[email]
    Insert user from database       ${user}
    
    Go to login page
    Submit login form        ${user}
    User should be logged in    ${user}[name]
    
    Logout from application
    Confirme logout
    
    # Tenta acessar rota protegida
    Go To    ${BASE_URL}/profile
    Wait For Load State    networkidle
    
    # Deve redirecionar para login
    ${current_url}=    Get Url
    Should Contain Any    ${current_url}    /login    /auth



CT-Auth-014 Deve encerrar sessão completamente
    [Documentation]    Verifica se sessão é encerrada completamente após logout
    [Tags]    auth    logout    session    positive
    
    ${user}    Create Dictionary
    ...    name=CT-Auth-014 Sessão Encerrada
    ...    email=ct-auth-014@mail.com
    ...    password=pwd123

    Remove user from database       ${user}[email]
    Insert user from database       ${user}
    
    Go to login page
    Submit login form        ${user}
    User should be logged in    ${user}[name]
    
    Logout from application
    Confirme logout
    
    # Verifica se não consegue acessar área logada
    Go To    ${BASE_URL}/reservations
    Wait For Load State    networkidle
    
    ${current_url}=    Get Url
    Should Contain Any    ${current_url}    /login    /auth    /home

CT-Auth-015 Deve exibir confirmação visual de logout
    [Documentation]    Verifica se há feedback visual após logout
    [Tags]    auth    logout    feedback    positive
    
    ${user}    Create Dictionary
    ...    name=CT-Auth-015 Confirmação Visual
    ...    email=ct-auth-015@mail.com
    ...    password=pwd123

    Remove user from database       ${user}[email]
    Insert user from database       ${user}
    
    Go to login page
    Submit login form        ${user}
    User should be logged in    ${user}[name]
    
    Logout from application
    Confirme logout
    
    # Verifica se voltou para estado não logado
    ${current_url}=    Get Url
    Should Not Contain    ${current_url}    /profile
    Should Not Contain    ${current_url}    /reservations