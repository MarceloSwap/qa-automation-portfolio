*** Settings ***
Documentation        Elementos e ações da página de cadastro

Resource       ../base.resource


*** Keywords ***
Confirme logout

    # Checkpoint 1: Espera e valida o título H1 da página de login.
    Wait For Elements State    css=h1 >> text=Login    visible    timeout=10s

    # Checkpoint 2: Valida o parágrafo de instrução.
    Wait For Elements State     css=.login-header >> text="Entre com suas credenciais para acessar sua conta"

