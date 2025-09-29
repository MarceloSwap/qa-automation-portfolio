*** Settings ***
Documentation       Cenário de testes do cadastro de usuários

Resource    ../resources/base.resource

# Test Setup        Log    Tudo aqui ocorre antes da Suite (antes de todos os testes)
# Test Teardown     Log    Tudo aqui ocorre deois da Suite (depois de todos os testes)

Test Setup        Start Session
Test Teardown     Take Screenshot
Library           OperatingSystem

*** Test Cases ***
CT001 Deve poder cadastrar um novo usuário
    [Tags]        CT001
    ${user}    Create Dictionary
    ...    name=Teste CT001
    ...    email=ct001@mail.com
    ...    password=pwd123

    #Limpando o banco mongodb, exclui o user pelo email pra iniciar os testes
    Remove user from database       ${user}[email]

    # test cases de signupPage
    Go to signup page
    Submit signup form        ${user}
    Notice should be          Boas vindas ao Mark85, o seu gerenciador de tarefas.

CT002 Não deve permitir o cadastro com email duplicado
    [Tags]        CT002
    ${user}    Create Dictionary
    ...    name=Teste CT002
    ...    email=ct002@mail.com
    ...    password=pwd123

    Remove user from database        ${user}[email]
    Insert user from database        ${user}

    # test cases de signupPage
    Go to signup page
    Submit signup form        ${user}
    Notice should be          Oops! Já existe uma conta com o e-mail informado.


CT003 Campos obrigatórios
    [Tags]        CT003
    ${user}        Create Dictionary
    ...            name=${EMPTY}
    ...            email=${EMPTY}
    ...            password=${EMPTY}

    Go to signup page
    Submit signup form        ${user}

    Alert should be    Informe seu nome completo
    Alert should be    Informe seu e-email
    Alert should be    Informe uma senha com pelo menos 6 digitos

CT004 Não deve cadastrar com email incorreto
    [Tags]        CT004
    ${user}            Create Dictionary
    ...                name=TestCT004
    ...                email=ct004.mail.com
    ...                password=pwd123
    
    Go to signup page
    Submit signup form        ${user}
    Alert should be           Digite um e-mail válido

CT005 Não deve cadastrar com senha muito curta
    [Tags]    temp

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

CT005 Não deve cadastrar com senha de 1 dígito
    [Tags]        CT005
    [Template]
    Short password CT005    1

CT005 Não deve cadastrar com senha de 2 dígito
    [Tags]        CT005
    [Template]
    Short password CT005    12
CT005 Não deve cadastrar com senha de 3 dígito
    [Tags]        CT005
    [Template]
     Short password CT005    123

CT005 Não deve cadastrar com senha de 4 dígito
    [Tags]        CT005
    [Template]
    Short password CT005    1234

CT005 Não deve cadastrar com senha de 5 dígito
    [Tags]        CT005
    [Template]
    Short password CT005    12345

*** Keywords ***
Short password CT005 
    [Arguments]    ${short_pass}
    ${user}        Create Dictionary
    ...            name=TestCT005
    ...            email=ct005@mail.com
    ...            password=${short_pass}

    Go to signup page
    Submit signup form        ${user}

    Alert should be    Informe uma senha com pelo menos 6 digitos