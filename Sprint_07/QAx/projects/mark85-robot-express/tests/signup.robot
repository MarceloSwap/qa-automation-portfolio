*** Settings ***
Documentation       Cenário de testes do cadastro de usuários

Resource    ../resources/base.robot

# Test Setup        Log    Tudo aqui ocorre antes da Suite (antes de todos os testes)
# Test Teardown     Log    Tudo aqui ocorre deois da Suite (depois de todos os testes)

Test Setup        Start Session
Test Teardown     Take Screenshot

*** Test Cases ***
Deve poder cadastrar um novo usuário
    
    ${user}    Create Dictionary
    ...    name=Teste CT001
    ...    email=ct001@mail.com
    ...    password=pwd123

    #Limpando o banco antes de cadastrar
    Remove user from database       ${user}[email]


    Go To    http://localhost:3000/signup

    # Tecnica Chekpoint (End-to-end)
    Wait For Elements State     xpath=//h1      visible     5
    Get Text                    xpath=//h1      equal       Faça seu cadastro

    Wait For Elements State     css=h1      visible     5
    Get Text                    css=h1      equal       Faça seu cadastro

    # #Procurar por css id camposINPUT
    # Fill Text    css=#name            Test QA000CSS
    # Fill Text    css=#email           Testqa000@mail.com  
    # Fill Text    css=#password        pwd123

    #Procurar por id (preencher texto) camposINPUT
    Fill Text    id=name        ${user}[name]
    Fill Text    id=email       ${user}[email]   
    Fill Text    id=password    ${user}[password]

    Click        id=buttonSignup

    Wait For Elements State        css=.notice p      visible        5

    #Validação da mensagens de boas vindas pra garantir que foi cadastrado
    Get Text                       css=.notice p      equal      Boas vindas ao Mark85, o seu gerenciador de tarefas.

    
Não deve permitir o cadastro com email duplicado
    [Tags]        dup

    ${user}    Create Dictionary
    ...    name=Teste CT002
    ...    email=ct002@mail.com
    ...    password=pwd123

    Remove user from database        ${user}[email]
    Insert user from database        ${user}



    Go To    http://localhost:3000/signup

    # Checkpoint pra garantir que está na pagina de cadastro
    Wait For Elements State     xpath=//h1      visible     5
    Get Text                    xpath=//h1      equal       Faça seu cadastro

    #Procurar por id (preencher texto) camposINPUT
    Fill Text    id=name        ${user}[name]
    Fill Text    id=email       ${user}[email]
    Fill Text    id=password    ${user}[password]

    Click        id=buttonSignup

    Wait For Elements State        css=.notice p      visible        5

    #Validação da mensagens de boas vindas pra garantir que foi cadastrado
    Get Text                       css=.notice p      equal      Oops! Já existe uma conta com o e-mail informado.