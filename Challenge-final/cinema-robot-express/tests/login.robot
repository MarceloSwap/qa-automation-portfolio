*** Settings ***
Documentation       Cenários de Autenticação do usuário

#Para ter acesso aos recursos da lib Browser
Resource          ../resources/base.resource
Library           Collections

Test Setup        Start Session
Test Teardown     Take Screenshot
#Library    OperatingSystem

*** Test Cases ***
CT005 Deve poder logar com um usário pré-cadastrado
    [Tags]    login
    ${user}    Create Dictionary
    ...    name=CT005 Login
    ...    email=ct005@mail.com
    ...    password=pwd123
    
    # Exclui o user de teste e garante que ele terá os dados iniciais corretos para os testes
    Remove user from database    ${user}[email]        
    
    Insert user from database    ${user}        # Garante que vou ter um user pra logar
    
    Submit login form        ${user}

# Verificando senha pequenas
# CT006 Sistema autentica credenciais válidas
#     [Tags]    login
#     ${user}    Create Dictionary
#     ...    name=CT006 Credenciais Válidas
#     ...    email=ct007@mail.com
#     ...    password=pwd123
    
#     # Exclui o user de teste e garante que ele terá os dados iniciais corretos para os testes
#     Remove user from database    ${user}[email]
#     # Garante que vou ter um user pra logar
#     Insert user from database    ${user}
    
#     # Usando a lib Collections para setar um valor diferente na senha
#     Set To Dictionary        ${user}        password=abc123

#     Submit login form        ${user}
#     # Aviso deve ter
#     Notice should be         Ocorreu um erro ao fazer login, verifique suas credenciais.