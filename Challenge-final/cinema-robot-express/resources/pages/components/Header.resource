*** Settings ***
Documentation       Ações e elementos do componente Header

Resource            ../../../resources/base.resource

*** Keywords ***
User should be logged in
    [Arguments]    ${user_name}

    # 1. Primeiro, esperamos por um elemento que só existe quando logado (ex: o botão Sair).
    #    Isso garante que a página já foi atualizada após o login.
    Wait For Elements State    css=button.btn-logout    visible    timeout=10s

User should be logged out
    Wait For Elements State    text=Login       visible    timeout=5s
    Wait For Elements State    text=Cadastrar   visible    timeout=5s

Navigate to Profile page
    Click    css=a[href="/profile"]

Navigate to My Reservations page
    Click    css=a[href="/reservations"]

Logout from application
    Click    css=button.btn-logout


