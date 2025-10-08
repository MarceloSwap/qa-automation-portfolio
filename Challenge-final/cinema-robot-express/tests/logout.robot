*** Settings ***
Documentation       Cenários de logout do usuário

#Para ter acesso aos recursos da lib Browser
Resource          ../resources/base.resource
Library           Collections

Test Setup        Start Session
Test Teardown     Take Screenshot
#Library    OperatingSystem

*** Test Cases ***
CT007 Logout de Usuário
    [Tags]        logout
    ${user}    Create Dictionary
    ...    name=Logout
    ...    email=logout@mail.com
    ...    password=pwd123

    #Limpando o banco mongodb, exclui o user pelo email pra iniciar os testes
    Remove user from database       ${user}[email]

    # test cases de signupPage
    Go to signup page
    Submit signup form        ${user}
    Notice should be        Conta criada com sucesso!    
    Logout from application
    Confirme logout
    Sleep    5
