*** Settings ***
Documentation       Testes de registro de usuário
...                 US-AUTH-001: Registro de Usuário

Resource    ../resources/base.resource

Test Setup       Start Session
Test Teardown    Take Screenshot

*** Test Cases ***
CT-Auth-001 Deve permitir registro de novo usuário
    [Documentation]    Verifica se é possível registrar uma nova conta com dados válidos

    ${user}    Create Dictionary
    ...    name=CT-Auth-001 Registro
    ...    email=ct-auth-001@mail.com
    ...    password=pwd123

    Remove user from database       ${user}[email]
    Go to signup page
    Submit signup form        ${user}
    Notice should be        Conta criada com sucesso!
    Remove user from database        ${user}[email]

CT-Auth-002 Não deve permitir registro com email duplicado
    [Documentation]    Verifica se sistema impede registros de emails duplicados
    
    ${user}    Create Dictionary
    ...    name=CT-Auth-002 Email Duplicado
    ...    email=ct-auth-002@mail.com
    ...    password=pwd123

    Remove user from database        ${user}[email]
    Insert user from database        ${user}
    Go to signup page
    Submit signup form        ${user}
    Alert should be          User already exists

CT-Auth-003 Não deve permitir registro com email inválido
    [Documentation]    Verifica validação de formato de email
    
    ${user}         Create Dictionary
    ...             name=CT-Auth-003 Email Inválido
    ...             email=ct-auth-003.mail.com
    ...             password=pwd123
    
    Go to signup page
    Fill signup fields    ${user}
    Field validation message should be    css=#email    Inclua um "@" no endereço

CT-Auth-004 Deve validar formato de senha
    [Documentation]    Verifica se sistema valida formato da senha
    
    ${user}    Create Dictionary
    ...    name=CT-Auth-004 Senha Inválida
    ...    email=ct-auth-004@mail.com
    ...    password=123

    Go to signup page
    Fill signup fields    ${user}
    # Verifica se há validação de senha muito curta

CT-Auth-005 Deve redirecionar após registro bem-sucedido
    [Documentation]    Verifica se usuário é redirecionado após registro
    
    ${user}    Create Dictionary
    ...    name=CT-Auth-005 Redirecionamento
    ...    email=ct-auth-005@mail.com
    ...    password=pwd123

    Remove user from database       ${user}[email]
    Go to signup page
    Submit signup form        ${user}
    Notice should be        Conta criada com sucesso!
    
    # Verifica se foi redirecionado ou autenticado
    ${current_url}=    Get Url
    Should Not Contain    ${current_url}    /register
    
    Remove user from database        ${user}[email]