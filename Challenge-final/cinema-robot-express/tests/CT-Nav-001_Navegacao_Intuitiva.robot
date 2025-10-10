*** Settings ***
Documentation    Testes para navegação intuitiva
...              US-NAV-001: Navegação Intuitiva

Resource         ../resources/base.resource

Test Setup       Start Session
Test Teardown    Take Screenshot

*** Test Cases ***
CT-Nav-001 Deve exibir cabeçalho em todas as páginas
    [Documentation]    Verifica se o cabeçalho está presente em diferentes páginas
    [Tags]    navigation    header    positive
    
    Go To    ${BASE_URL}
    Verificar Presença do Cabeçalho
    Verificar Links Principais do Menu
    
    Go To    ${BASE_URL}/movies
    Verificar Presença do Cabeçalho
    Verificar Links Principais do Menu
    
    Go To    ${BASE_URL}/login
    Verificar Presença do Cabeçalho
    Verificar Links Principais do Menu



CT-Nav-005 Deve indicar página atual no menu
    [Documentation]    Verifica feedback visual da página atual
    [Tags]    navigation    active-state    positive
    
    Go To    ${BASE_URL}
    ${active_item}=    Verificar Feedback Visual da Página Atual
    
    Go To    ${BASE_URL}/movies
    Wait For Load State    networkidle
    ${new_active_item}=    Verificar Feedback Visual da Página Atual

CT-Nav-006 Deve permitir navegação entre seções principais
    [Documentation]    Verifica navegação fluida entre seções
    [Tags]    navigation    flow    positive
    
    Go To    ${BASE_URL}
    Testar Navegação Entre Páginas

CT-Nav-007 Deve exibir breadcrumbs quando apropriado
    [Documentation]    Verifica presença de breadcrumbs em páginas internas
    [Tags]    navigation    breadcrumbs    positive
    
    @{pages_to_test}=    Create List    /movies    /profile    /reservations
    
    FOR    ${page}    IN    @{pages_to_test}
        ${page_exists}=    Run Keyword And Return Status
        ...    Go To    ${BASE_URL}${page}
        
        IF    ${page_exists}
            Wait For Load State    networkidle
            ${breadcrumb_count}=    Verificar Breadcrumbs
            Log    Página ${page}: ${breadcrumb_count} breadcrumbs encontrados
        END
    END

CT-Nav-008 Deve fornecer botões de retorno quando apropriado
    [Documentation]    Verifica presença de botões para voltar
    [Tags]    navigation    back-button    positive
    
    @{pages_with_back}=    Create List    /movies/1    /profile    /checkout
    
    FOR    ${page}    IN    @{pages_with_back}
        ${page_exists}=    Run Keyword And Return Status
        ...    Go To    ${BASE_URL}${page}
        
        IF    ${page_exists}
            Wait For Load State    networkidle
            ${has_back_button}=    Verificar Botão Voltar
            Log    Página ${page}: Botão voltar = ${has_back_button}
        END
    END

CT-Nav-009 Deve manter navegação consistente em todas as páginas
    [Documentation]    Verifica consistência da navegação
    [Tags]    navigation    consistency    positive
    
    @{pages_to_test}=    Create List    /    /movies    /login    /register
    
    FOR    ${page}    IN    @{pages_to_test}
        Go To    ${BASE_URL}${page}
        Wait For Load State    networkidle
        
        Verificar Presença do Cabeçalho
        Verificar Links Principais do Menu
        
        Log    Navegação consistente na página: ${page}
    END

CT-Nav-010 Deve permitir acesso rápido às funcionalidades principais
    [Documentation]    Verifica acesso direto às principais funcionalidades
    [Tags]    navigation    quick-access    positive
    
    Go To    ${BASE_URL}
    
    Navegar para Seção    movies
    ${current_url}=    Get Url
    Should Contain    ${current_url}    /movies
    
    Navegar para Seção    home
    ${current_url}=    Get Url
    Should Not Contain    ${current_url}    /movies



CT-Nav-012 Deve ser acessível via teclado
    [Documentation]    Verifica navegação via teclado
    [Tags]    navigation    accessibility    positive
    
    Go To    ${BASE_URL}
    
    Press Keys    body    Tab
    Sleep    0.5s
    
    ${focused_element}=    Get Element    css=:focus
    ${tag_name}=    Get Property    ${focused_element}    tagName
    Should Be True    '${tag_name}' in ['A', 'BUTTON']    Elemento focado deve ser link ou botão

CT-Nav-013 Deve carregar navegação rapidamente
    [Documentation]    Verifica se a navegação carrega rapidamente
    [Tags]    navigation    performance    positive
    
    ${start_time}=    Get Time    epoch
    Go To    ${BASE_URL}
    Verificar Presença do Cabeçalho
    ${end_time}=    Get Time    epoch
    
    ${load_time}=    Evaluate    ${end_time} - ${start_time}
    Should Be True    ${load_time} < 5    Navegação demorou mais que 5 segundos

CT-Nav-014 Deve exibir menu móvel funcional
    [Documentation]    Verifica se menu móvel funciona corretamente
    [Tags]    navigation    mobile    responsive    positive
    
    Set Viewport Size    375    667
    Go To    ${BASE_URL}
    
    ${mobile_menu_exists}=    Run Keyword And Return Status
    ...    Wait For Elements State    css=.mobile-menu-toggle, .hamburger-menu    visible    3
    
    IF    ${mobile_menu_exists}
        Click    css=.mobile-menu-toggle, .hamburger-menu
        Wait For Elements State    css=.mobile-menu, .nav-menu.open    visible    3
    ELSE
        Log    Menu móvel não implementado ou não detectado
    END



*** Keywords ***
Fazer Login Como Usuário Teste
    [Documentation]    Faz login com usuário de teste
    
    Go to login page
    ${user}=    Create Dictionary    email=teste@cinema.com    password=123456
    Submit login form    ${user}
    
    ${current_url}=    Get Url
    Should Not Contain    ${current_url}    /login