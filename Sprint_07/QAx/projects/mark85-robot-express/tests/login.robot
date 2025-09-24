*** Settings ***
Documentation       Cenários de Autenticação do usuário

#Para ter acesso aos recursos da lib Browser
Resource          ../resources/base.resource
Library           Collections

Test Setup        Start Session
Test Teardown     Take Screenshot
#Library    OperatingSystem

*** Test Cases ***
CT006 Deve poder logar com um usário pré-cadastrado
    [Tags]    CT006
    ${user}    Create Dictionary
    ...    name=TestCT006
    ...    email=ct006@mail.com
    ...    password=pwd123
    
    # Exclui o user de teste e garante que ele terá os dados iniciais corretos para os testes
    Remove user from database    ${user}[email]        
    
    Insert user from database    ${user}        # Garante que vou ter um user pra logar
    
    Submit login form        ${user}
    User should be logger in       ${user}[name]

CT007 Não deve logar com senha inválida
    [Tags]    CT007
    ${user}    Create Dictionary
    ...    name=TestCT007
    ...    email=ct007@mail.com
    ...    password=pwd123
    
    # Exclui o user de teste e garante que ele terá os dados iniciais corretos para os testes
    Remove user from database    ${user}[email]
    # Garante que vou ter um user pra logar
    Insert user from database    ${user}
    
    # Usando a lib Collections para setar um valor diferente na senha
    Set To Dictionary        ${user}        password=abc123

    Submit login form        ${user}
    # Aviso deve ter
    Notice should be         Ocorreu um erro ao fazer login, verifique suas credenciais.