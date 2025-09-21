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

    #Limpando o banco mongodb, exclui o user pelo email pra iniciar os testes
    Remove user from database       ${user}[email]

    # test cases de signupPage
    Go to signup page
    Submit signup form        ${user}
    Notice should be          Boas vindas ao Mark85, o seu gerenciador de tarefas.

Não deve permitir o cadastro com email duplicado
    [Tags]        dup

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

# um pouco docódigo antes de aplicar Page Objetct
#     *** Settings ***
# Documentation       Cenário de testes do cadastro de usuários

# Resource    ../resources/base.robot

# # Test Setup        Log    Tudo aqui ocorre antes da Suite (antes de todos os testes)
# # Test Teardown     Log    Tudo aqui ocorre deois da Suite (depois de todos os testes)

# Test Setup        Start Session
# Test Teardown     Take Screenshot

# *** Test Cases ***
# Deve poder cadastrar um novo usuário
    
#     ${user}    Create Dictionary
#     ...    name=Teste CT001
#     ...    email=ct001@mail.com
#     ...    password=pwd123

#     #Limpando o banco mongodb, exclui o user pelo email pra iniciar os testes
#     Remove user from database       ${user}[email]

#     # test cases de signupPage
#     Go to signup page
#     Submit signup form        ${user}
#     Notice should be          Boas Vindas ao Mark85, o seu gerencador de tarefas.

#     # #Procurar por css id camposINPUT
#     # Fill Text    css=#name            Test QA000CSS
#     # Fill Text    css=#email           Testqa000@mail.com  
#     # Fill Text    css=#password        pwd123

#     # #Procurar por id (preencher texto) camposINPUT
#     # Fill Text    id=name        ${user}[name]
#     # Fill Text    id=email       ${user}[email]   
#     # Fill Text    id=password    ${user}[password]
#     # Click        id=buttonSignup
    
# Não deve permitir o cadastro com email duplicado
#     [Tags]        dup

#     ${user}    Create Dictionary
#     ...    name=Teste CT002
#     ...    email=ct002@mail.com
#     ...    password=pwd123

#     Remove user from database        ${user}[email]
#     Insert user from database        ${user}

#     Go To    ${BASE_URL}/signup

#     # Checkpoint pra garantir que está na pagina de cadastro
#     Wait For Elements State     xpath=//h1      visible     5
#     Get Text                    xpath=//h1      equal       Faça seu cadastro

#     # #Procurar por id (preencher texto) camposINPUT
#     # Fill Text    id=name        ${user}[name]
#     # Fill Text    id=email       ${user}[email]
#     # Fill Text    id=password    ${user}[password]

#     # Click        id=buttonSignup

#     #Procurar por css name ou placehouder (caso não tenha id)
#     Fill Text    css=input[name=name]           ${user}[name]
#     Fill Text    css=input[name=email]          ${user}[email]  
#     Fill Text    css=input[name=password]       ${user}[password]

#     #Exemplo de combinação cd css com text
#     Click        css=[type=submit] >> text=Cadastrar

#     Wait For Elements State        css=.notice p      visible        5
#     #Validação da mensagens de boas vindas pra garantir que foi cadastrado
#     Get Text                       css=.notice p      equal      Oops! Já existe uma conta com o e-mail informado.