    
*** Settings ***
Documentation       Cenário de testes do cadastro de usuários

Resource    ../resources/base.resource

# Test Setup        Log    Tudo aqui ocorre antes da Suite (antes de todos os testes)
# Test Teardown     Log    Tudo aqui ocorre deois da Suite (depois de todos os testes)

Test Setup        Start Session
Test Teardown     Take Screenshot

Library    Dialogs

*** Test Cases ***
CT001 Registro de Usuário
    [Tags]        create
    ${user}    Create Dictionary
    ...    name=TestCT001
    ...    email=ct001@mail.com
    ...    password=pwd123

    #Limpando o banco mongodb, exclui o user pelo email pra iniciar os testes
    Remove user from database       ${user}[email]

    # test cases de signupPage
    Go to signup page
    Submit signup form        ${user}
    Notice should be        Conta criada com sucesso!

CT002 Não deve permitir o cadastro com email duplicado
    [Tags]        create
    ${user}    Create Dictionary
    ...    name=Teste CT002
    ...    email=ct002@mail.com
    ...    password=pwd123
    ...    confirmPassword=pwd123

    Remove user from database        ${user}[email]
    Insert user from database        ${user}

    # test cases de signupPage
    Go to signup page
    Submit signup form        ${user}
    Alert should be          User already exists

CT003 Não deve cadastrar com email incorreto
    [Tags]        create
    ${user}            Create Dictionary
    ...                name=TestCT004
    ...                email=ct004.mail.com
    ...                password=pwd123
    ...                confirmPassword=pwd123
    
    Go to signup page
    Submit signup form        ${user}
    Alert should be           Inclua um "@" no endereço de email.

CT004 Não deve cadastrar com senha muito curta
    [Tags]        create

    @{password_list}    Create List    1    12    123    1234    12345

    FOR    ${password}    IN    @{password_list}
        ${user}    Create Dictionary
    ...            name=TestCT005
    ...            email=ct005@mail.com
    ...            password=${password}

        Go to signup page
        Submit signup form        ${user}

        Alert should be    Informe uma senha com pelo menos 6 digitos
        
    END