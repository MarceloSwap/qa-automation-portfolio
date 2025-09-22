*** Settings ***
Documentation       Cenários de Autenticação do usuário

#Para ter acesso aos recursos da lib Browser
Resource    ../resources/base.resource

Test Setup        Start Session
Test Teardown     Take Screenshot
Library    OperatingSystem

*** Test Cases ***
CT006 Deve poder logar com um usário pré-cadastrado
    [Tags]    CT006
    ${user}    Create Dictionary
    ...    name=TestCT001
    ...    email=ct001@mail.com
    ...    password=pwd123
    
    Submit login form CT006        ${user}
    User should be logger in       ${user}[name]