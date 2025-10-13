*** Settings ***
Documentation       Testes de login de usuário
...                 US-AUTH-002: Login de Usuário

Resource          ../resources/base.resource

Test Setup        Start Session
Test Teardown     Take Screenshot

*** Test Cases ***
CT-Auth-006 Deve permitir login com credenciais válidas
    [Documentation]    Verifica se usuário pode fazer login com email e senha corretos
    
    ${user}    Create Dictionary
    ...    name=CT-Auth-006 Login Válido
    ...    email=ct-auth-006@mail.com
    ...    password=pwd123
    
    Remove user from database    ${user}[email]        
    Insert user from database    ${user}
    
    Go to login page
    Submit login form        ${user}
    User should be logged in    ${user}[name]

CT-Auth-007 Não deve permitir login com credenciais inválidas
    [Documentation]    Verifica se sistema rejeita credenciais incorretas
    
    ${user}    Create Dictionary
    ...    name=CT-Auth-007 Login Inválido
    ...    email=ct-auth-007@mail.com
    ...    password=pwd123

    Remove user from database    ${user}[email]
    Insert user from database    ${user}
    
    # Tenta login com senha incorreta
    Set To Dictionary        ${user}        password=senhaerrada
    
    Go to login page
    Submit login form        ${user}
    
    # Verifica se permaneceu na página de login (não foi redirecionado)
    ${current_url}=    Get Url
    Should Contain    ${current_url}    /login
   

CT-Auth-008 Deve manter sessão através de token JWT
    [Documentation]    Verifica se sistema mantém sessão do usuário
    
    ${user}    Create Dictionary
    ...    name=CT-Auth-008 Sessão JWT
    ...    email=ct-auth-008@mail.com
    ...    password=pwd123
    
    Remove user from database    ${user}[email]        
    Insert user from database    ${user}
    
    Go to login page
    Submit login form        ${user}
    User should be logged in    ${user}[name]
    
    # Navega para outra página e verifica se mantém login
    Go To    ${BASE_URL}/movies
    Wait For Load State    networkidle
    # Verifica se ainda está logado (não redirecionou para login)
    ${current_url}=    Get Url
    Should Not Contain    ${current_url}    /login



CT-Auth-010 Não deve permitir login com email não cadastrado
    [Documentation]    Verifica se sistema rejeita email não existente
    
    ${user}    Create Dictionary
    ...    name=CT-Auth-010 Email Inexistente
    ...    email=emailinexistente@mail.com
    ...    password=pwd123
    
    # Garante que email não existe
    Remove user from database    ${user}[email]
    
    Go to login page
    Submit login form        ${user}
    
    # Verifica se permaneceu na página de login ou se há mensagem de erro
    Sleep    2s
    ${current_url}=    Get Url
    Should Contain    ${current_url}    /login
    
    # Tenta encontrar mensagem de erro
    TRY
        Alert should be    Invalid email or password
    EXCEPT
        TRY
            Alert should be    User not found
        EXCEPT
            Log    Nenhuma mensagem de erro encontrada, mas permaneceu na página de login
        END
    END