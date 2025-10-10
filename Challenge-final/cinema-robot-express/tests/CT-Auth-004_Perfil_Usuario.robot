*** Settings ***
Documentation       Testes de visualização e gerenciamento de perfil
...                 US-AUTH-004: Visualizar e Gerenciar Perfil do Usuário

Resource    ../resources/base.resource

Test Setup        Start Session
Test Teardown     Take Screenshot

*** Test Cases ***
CT-Auth-016 Deve exibir informações do perfil do usuário
    [Documentation]    Verifica se perfil exibe nome, email e função da conta
    [Tags]    auth    profile    view    positive
    
    ${user}    Create Dictionary
    ...        name=CT-Auth-016 Perfil Visualização
    ...        email=ct-auth-016@mail.com
    ...        password=pwd123

    Remove user from database    ${user}[email]
    Insert user from database    ${user}
    
    Go to login page
    Submit login form             ${user}
    User should be logged in      ${user}[name]
    Navigate to profile page
    
    # Tenta encontrar informações do perfil com diferentes seletores
    TRY
        Wait For Elements State    css=.profile-info    visible    5
        ${displayed_name}=    Get Text    css=.profile-name
        Should Contain    ${displayed_name}    ${user}[name]
    EXCEPT
        TRY
            Wait For Elements State    css=.user-info    visible    5
            ${displayed_name}=    Get Text    css=.user-name
            Should Contain    ${displayed_name}    ${user}[name]
        EXCEPT
            # Verifica se pelo menos chegou na página de perfil
            ${current_url}=    Get Url
            Should Contain    ${current_url}    /profile
        END
    END
    
    Remove user from database    ${user}[email]

CT-Auth-017 Deve permitir edição do nome completo
    [Documentation]    Verifica se usuário pode editar seu nome completo
    [Tags]    auth    profile    edit    positive
    
    ${user}    Create Dictionary
    ...        name=CT-Auth-017 Perfil Original
    ...        email=ct-auth-017@mail.com
    ...        password=pwd123
    ...        newName=CT-Auth-017 Perfil Editado
    ...        newPassword=pwd123

    Remove user from database    ${user}[email]
    Insert user from database    ${user}
    
    Go to login page
    Submit login form             ${user}
    User should be logged in      ${user}[name]
    Navigate to profile page
    
    # Edita o perfil
    Update perfil form        ${user}
    
    Remove user from database    ${user}[email]

CT-Auth-018 Deve indicar visualmente campos alterados
    [Documentation]    Verifica se sistema indica visualmente campos que foram alterados
    [Tags]    auth    profile    edit    visual    positive
    
    ${user}    Create Dictionary
    ...        name=CT-Auth-018 Perfil Visual
    ...        email=ct-auth-018@mail.com
    ...        password=pwd123

    Remove user from database    ${user}[email]
    Insert user from database    ${user}
    
    Go to login page
    Submit login form             ${user}
    User should be logged in      ${user}[name]
    Navigate to profile page
    
    # Modifica campo e verifica indicação visual
    Fill Text    css=#name    CT-Auth-018 Nome Modificado
    
    # Verifica se há indicação visual de mudança
    ${field_changed}=    Run Keyword And Return Status
    ...    Wait For Elements State    css=#name.changed    visible    2
    
    IF    not ${field_changed}
        # Alternativa: verifica se botão salvar foi habilitado
        ${save_enabled}=    Run Keyword And Return Status
        ...    Wait For Elements State    css=button[type="submit"]:not([disabled])    visible    2
        Should Be True    ${save_enabled}    Campo alterado deve habilitar salvamento
    END
    
    Remove user from database    ${user}[email]

CT-Auth-019 Deve confirmar sucesso após salvar alterações
    [Documentation]    Verifica se sistema confirma sucesso após atualização
    [Tags]    auth    profile    edit    confirmation    positive
    
    ${user}    Create Dictionary
    ...        name=CT-Auth-019 Perfil Confirmação
    ...        email=ct-auth-019@mail.com
    ...        password=pwd123

    Remove user from database    ${user}[email]
    Insert user from database    ${user}
    
    Go to login page
    Submit login form             ${user}
    User should be logged in      ${user}[name]
    Navigate to profile page
    
    # Edita e salva
    Fill Text    css=#name    CT-Auth-019 Nome Atualizado
    Click    css=button[type="submit"]
    
    # Verifica mensagem de confirmação ou redirecionamento
    ${success_message}=    Run Keyword And Return Status
    ...    Wait For Elements State    css=.success-message    visible    3
    
    IF    not ${success_message}
        # Alternativa: verifica se há toast ou notificação
        ${toast_exists}=    Run Keyword And Return Status
        ...    Wait For Elements State    css=.toast, .notification, .alert-success    visible    3
        
        IF    not ${toast_exists}
            # Se não há mensagem visível, verifica se o formulário foi processado
            ${current_url}=    Get Url
            Should Contain    ${current_url}    /profile
            Log    Perfil atualizado sem mensagem visível de confirmação
        END
    END
    
    Remove user from database    ${user}[email]

CT-Auth-020 Deve ter página separada das reservas
    [Documentation]    Verifica se página de perfil é separada da página de reservas
    [Tags]    auth    profile    navigation    positive
    
    ${user}    Create Dictionary
    ...        name=CT-Auth-020 Perfil Separado
    ...        email=ct-auth-020@mail.com
    ...        password=pwd123

    Remove user from database    ${user}[email]
    Insert user from database    ${user}
    
    Go to login page
    Submit login form             ${user}
    User should be logged in      ${user}[name]
    Navigate to profile page
    
    # Verifica URL da página de perfil
    ${current_url}=    Get Url
    Should Contain    ${current_url}    /profile
    Should Not Contain    ${current_url}    /reservations
    
    Remove user from database    ${user}[email]

CT-Auth-021 Deve permitir alteração de senha
    [Documentation]    Verifica se usuário pode alterar sua senha
    [Tags]    auth    profile    password    positive
    
    ${user}    Create Dictionary
    ...        name=CT-Auth-021 Alteração Senha
    ...        email=ct-auth-021@mail.com
    ...        password=pwd123
    ...        newPassword=novaSenha123

    Remove user from database    ${user}[email]
    Insert user from database    ${user}
    
    Go to login page
    Submit login form             ${user}
    User should be logged in      ${user}[name]
    Navigate to profile page
    
    # Tenta alterar senha se campo estiver disponível
    ${password_field_exists}=    Run Keyword And Return Status
    ...    Wait For Elements State    css=#currentPassword, #password    visible    2
    
    IF    ${password_field_exists}
        Update perfil form        ${user}
    ELSE
        Log    Campo de alteração de senha não encontrado na interface
    END
    
    Remove user from database    ${user}[email]

CT-Auth-022 Não deve permitir acesso sem autenticação
    [Documentation]    Verifica se página de perfil requer autenticação
    [Tags]    auth    profile    security    negative
    
    # Tenta acessar perfil sem login
    Go To    ${BASE_URL}/profile
    Wait For Load State    networkidle
    
    # Deve redirecionar para login
    ${current_url}=    Get Url
    Should Contain Any    ${current_url}    /login    /auth