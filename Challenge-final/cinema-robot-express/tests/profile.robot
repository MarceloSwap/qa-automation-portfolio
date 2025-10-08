    
*** Settings ***
Documentation       Cenário de testes gerenciador de perfil do usuário

Resource    ../resources/base.resource


Test Setup        Start Session
Test Teardown     Take Screenshot

*** Test Cases ***
CT008 Visualizar perfil do usuário após o login
    [Tags]    profile
    ${user}    Create Dictionary
    ...        name=CT008 Perfil User
    ...        email=ct008perfil@mail.com
    ...        password=pwd123

    # GIVEN (Dado que) eu tenho um usuário cadastrado
    Remove user from database    ${user}[email]
    Insert user from database    ${user}
    

    
# WHEN (Quando) eu faço login na aplicação
    Go to login page
    
    Submit login form             ${user}
# A chamada do keyword acontece aqui, logo após o login
    User should be logged in      ${user}[name]
# AND (E) eu navego para a página de perfil
    Navigate to profile page
    Sleep    1
    Remove user from database    ${user}[email]

CT009 Editar perfil do usuário
    [Tags]    profile
    ${user}    Create Dictionary
    ...        name=CT009 Perfil User Editado
    ...        email=ct009perfil@mail.com
    ...        password=pwd123
    ...        newPassword=pwd1234

    # GIVEN (Dado que) eu tenho um usuário cadastrado
    Remove user from database    ${user}[email]
    Insert user from database    ${user}
    

    
# WHEN (Quando) eu faço login na aplicação
    Go to login page
    
    Submit login form             ${user}
# A chamada do keyword acontece aqui, logo após o login
    User should be logged in      ${user}[name]
# AND (E) eu navego para a página de perfil
    Navigate to profile page
    Sleep    1

# Usuário pode editar seu nome completo
    Update perfil form        ${user}
    Remove user from database    ${user}[email]
    
    
    