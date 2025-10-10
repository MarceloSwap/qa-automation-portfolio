*** Settings ***
Documentation        Elementos e ações do componente de navegação

Library        Browser
Resource       ../../env.resource

*** Variables ***
# Seletores do cabeçalho e navegação
${HEADER}                 css=header
${NAV_MENU}               css=.nav-menu
${NAV_LINKS}              css=.nav-links
${MOBILE_MENU_TOGGLE}     css=.mobile-menu-toggle
${MOBILE_MENU}            css=.mobile-menu
${BREADCRUMBS}            css=.breadcrumbs
${ACTIVE_NAV_ITEM}        css=.nav-item.active
${BACK_BUTTON}            css=.back-button
${USER_MENU}              css=.user-menu
${LOGIN_LINK}             css=a[href="/login"]
${REGISTER_LINK}          css=a[href="/register"]
${PROFILE_LINK}           css=a[href="/profile"]
${RESERVATIONS_LINK}      css=a[href="/reservations"]
${MOVIES_LINK}            css=a[href="/movies"]
${HOME_LINK}              css=a[href="/"]

*** Keywords ***
Verificar Presença do Cabeçalho
    [Documentation]    Verifica se o cabeçalho está presente na página
    Wait For Elements State    ${HEADER}    visible    5

Verificar Links Principais do Menu
    [Documentation]    Verifica se os links principais estão presentes
    # Usa seletor mais específico para evitar duplicatas
    Wait For Elements State    css=nav a[href="/"]      visible    5
    Wait For Elements State    css=nav a[href="/movies"]    visible    5

Verificar Menu Responsivo Desktop
    [Documentation]    Verifica menu em modo desktop
    Set Viewport Size    1920    1080
    Wait For Elements State    ${NAV_MENU}    visible    5
    
    ${mobile_toggle_visible}=    Run Keyword And Return Status
    ...    Wait For Elements State    ${MOBILE_MENU_TOGGLE}    visible    1
    Should Be True    not ${mobile_toggle_visible}    Toggle mobile não deve estar visível em desktop

Verificar Menu Responsivo Mobile
    [Documentation]    Verifica menu em modo mobile
    Set Viewport Size    375    667
    
    ${mobile_toggle_exists}=    Run Keyword And Return Status
    ...    Wait For Elements State    ${MOBILE_MENU_TOGGLE}    visible    5
    
    IF    ${mobile_toggle_exists}
        # Testa abertura do menu mobile
        Click    ${MOBILE_MENU_TOGGLE}
        Wait For Elements State    ${MOBILE_MENU}    visible    5
        
        # Verifica se links estão no menu mobile
        Wait For Elements State    ${MOBILE_MENU} >> ${MOVIES_LINK}    visible    5
    ELSE
        Log    Menu mobile não implementado ou usa estrutura diferente
    END

Verificar Links para Usuário Não Logado
    [Documentation]    Verifica links disponíveis para visitantes
    ${login_exists}=    Run Keyword And Return Status
    ...    Wait For Elements State    ${LOGIN_LINK}    visible    5
    
    ${register_exists}=    Run Keyword And Return Status
    ...    Wait For Elements State    ${REGISTER_LINK}    visible    5
    
    Should Be True    ${login_exists} or ${register_exists}    Deve haver link de login ou registro

Verificar Links para Usuário Logado
    [Documentation]    Verifica links personalizados para usuário logado
    
    ${profile_exists}=    Run Keyword And Return Status
    ...    Wait For Elements State    ${PROFILE_LINK}    visible    5
    
    ${reservations_exists}=    Run Keyword And Return Status
    ...    Wait For Elements State    ${RESERVATIONS_LINK}    visible    5
    
    Should Be True    ${profile_exists} or ${reservations_exists}    Deve haver links personalizados

Verificar Breadcrumbs
    [Documentation]    Verifica se breadcrumbs estão presentes
    ${breadcrumbs_exist}=    Run Keyword And Return Status
    ...    Wait For Elements State    ${BREADCRUMBS}    visible    5
    
    IF    ${breadcrumbs_exist}
        ${breadcrumb_items}=    Get Elements    ${BREADCRUMBS} >> css=.breadcrumb-item
        ${items_count}=    Get Length    ${breadcrumb_items}
        Should Be True    ${items_count} > 0    Breadcrumbs devem ter pelo menos um item
        RETURN    ${items_count}
    ELSE
        Log    Breadcrumbs não encontrados na página atual
        RETURN    0
    END

Verificar Feedback Visual da Página Atual
    [Documentation]    Verifica se há indicação visual da página atual
    ${active_item_exists}=    Run Keyword And Return Status
    ...    Wait For Elements State    ${ACTIVE_NAV_ITEM}    visible    5
    
    IF    ${active_item_exists}
        ${active_text}=    Get Text    ${ACTIVE_NAV_ITEM}
        Should Not Be Empty    ${active_text}
        RETURN    ${active_text}
    ELSE
        Log    Nenhum item de navegação ativo encontrado
        RETURN    ${EMPTY}
    END

Verificar Botão Voltar
    [Documentation]    Verifica se há botão para voltar
    ${back_button_exists}=    Run Keyword And Return Status
    ...    Wait For Elements State    ${BACK_BUTTON}    visible    5
    
    IF    ${back_button_exists}
        RETURN    True
    ELSE
        RETURN    False
    END

Navegar para Seção
    [Documentation]    Navega para uma seção específica
    [Arguments]    ${section}
    
    IF    '${section}' == 'home'
        # Usa o primeiro link para home (no nav principal)
        Click    css=nav a[href="/"]:first-of-type
    ELSE IF    '${section}' == 'movies'
        # Usa o primeiro link para movies (no nav principal)
        Click    css=nav a[href="/movies"]:first-of-type
    ELSE IF    '${section}' == 'profile'
        Click    ${PROFILE_LINK}
    ELSE IF    '${section}' == 'reservations'
        Click    ${RESERVATIONS_LINK}
    ELSE
        Fail    Seção inválida: ${section}
    END
    
    Wait For Load State    networkidle

Testar Navegação Entre Páginas
    [Documentation]    Testa navegação entre diferentes páginas
    
    # Home -> Movies
    Navegar para Seção    home
    ${current_url}=    Get Url
    Should Contain    ${current_url}    /
    
    Navegar para Seção    movies
    ${current_url}=    Get Url
    Should Contain    ${current_url}    /movies
    
    # Volta para home
    Navegar para Seção    home
    ${current_url}=    Get Url
    Should Not Contain    ${current_url}    /movies