*** Settings ***
Documentation       Keywords e elementos da página de Perfil do Usuário

Resource            ../env.resource

Library    Browser

*** Keywords ***
Profile page should be visible
    [Arguments]    ${user_name}

    # Passo 1: Verifica se o título "Meu Perfil" está visível.
    # Este é um bom checkpoint para garantir que a página correta carregou.
    Wait For Elements State    css=h1 >> text=Meu Perfil    visible    timeout=10s

    # Passo 2: Verifica se o campo de input 'name' contém o nome correto do usuário.
    # "Get Value" é usado para ler o valor de campos de formulário (inputs).
    ${value_in_field}=    Get Variable Value    css=#name
    Should Be Equal As Strings    ${value_in_field}    ${user_name}

Update perfil form
    [Arguments]    ${user}

    # Usando o seletor de ID (css=#) que é mais específico e confiável
    Fill Text    css=#name               ${user}[name]
    Sleep    0.5
    Fill Text    id=currentPassword           ${user}[password]
    Sleep    0.5
    Fill Text    id=newPassword    ${user}[newPassword]
    Sleep    0.5
    Fill Text    id=confirmNewPassword    ${user}[newPassword]
    Sleep    0.5
    # Seu seletor para o botão já estava ótimo!
    Click        css=button[title="Salvar alterações"]
    Sleep    3

    
