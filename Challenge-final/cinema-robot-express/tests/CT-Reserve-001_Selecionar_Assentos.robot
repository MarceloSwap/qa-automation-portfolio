*** Settings ***
Documentation    US-RESERVE-001: Selecionar Assentos para Reserva
Resource         ../resources/base.resource
Suite Setup      Start Session
Suite Teardown   Close Browser
Test Tags        US-RESERVE-001

*** Test Cases ***
CT-001: Visualizar Layout de Assentos
    [Documentation]    Usuário pode visualizar o layout de assentos do teatro
    
    # Preparar usuário limpo
    ${user}=    Get fixture    users    valid_user
    
    # Remover usuário do banco se existir
    Remove user from database    ${user['email']}
    
    # Registrar o usuário
    Go To    ${BASE_URL}/register
    Fill Text    id=name    ${user['name']}
    Fill Text    id=email    ${user['email']}
    Fill Text    id=password    ${user['password']}
    Fill Text    id=confirmPassword    ${user['password']}
    Click    css=button[type="submit"]
    
    # Fazer login
    Go to login page
    Fill Text    id=email    ${user['email']}
    Fill Text    id=password    ${user['password']}
    Click    css=button >> text=Entrar
    
    # Navegar para filmes e selecionar um
    Go To Movies Page
    Wait For Elements State    css=.movie-card    visible    10
    Click    css=.movie-card >> nth=0 >> css=.btn-primary
    Wait For Load State    networkidle
    
    # Verificar se chegou na página de detalhes ou assentos
    ${current_url}=    Get Url
    IF    '/movies/' in '${current_url}'
        # Se estiver na página de detalhes, procurar botão de sessões
        ${session_btn_exists}=    Run Keyword And Return Status
        ...    Wait For Elements State    css=.session-btn, .select-seats-btn    visible    5
        IF    ${session_btn_exists}
            Click    css=.session-btn:first-child, .select-seats-btn:first-child
            Wait For Load State    networkidle
        END
    END
    
    # Verificar layout de assentos
    Should Display Seats Layout
    Should Display Seat Legend
    Should Display Available Seats
    Should Display Occupied Seats



CT-002: Codificação de Cores dos Assentos
    [Documentation]    Assentos são codificados por cores conforme disponibilidade
    
    # Usar o mesmo fluxo do CT-001 para chegar na página de assentos
    ${user}=    Get fixture    users    valid_user
    Remove user from database    ${user['email']}
    Go To    ${BASE_URL}/register
    Fill Text    id=name    ${user['name']}
    Fill Text    id=email    ${user['email']}
    Fill Text    id=password    ${user['password']}
    Fill Text    id=confirmPassword    ${user['password']}
    Click    css=button[type="submit"]
    Go to login page
    Fill Text    id=email    ${user['email']}
    Fill Text    id=password    ${user['password']}
    Click    css=button >> text=Entrar
    Go To Movies Page
    Wait For Elements State    css=.movie-card    visible    10
    Click    css=.movie-card >> nth=0 >> css=.btn-primary
    Wait For Load State    networkidle
    
    # Verificar se chegou na página de detalhes ou assentos
    ${current_url}=    Get Url
    IF    '/movies/' in '${current_url}'
        ${session_btn_exists}=    Run Keyword And Return Status
        ...    Wait For Elements State    css=.session-btn, .select-seats-btn    visible    5
        IF    ${session_btn_exists}
            Click    css=.session-btn:first-child, .select-seats-btn:first-child
            Wait For Load State    networkidle
        END
    END
    
    # Verificar cores dos assentos
    Should Display Green Available Seats
    Should Display Red Occupied Seats
    Should Display Blue Selected Seats

CT-003: Selecionar Múltiplos Assentos Disponíveis
    [Documentation]    Usuário pode selecionar múltiplos assentos disponíveis
    
    # Navegar para página de assentos
    Go To Seats Page
    
    # Selecionar primeiro assento
    Select Available Seat    A1
    Should Show Seat As Selected    A1
    
    # Selecionar segundo assento
    Select Available Seat    A2
    Should Show Seat As Selected    A2
    
    # Verificar contador de assentos
    Should Show Selected Seats Count    2

CT-004: Não Permitir Seleção de Assentos Ocupados
    [Documentation]    Usuário não pode selecionar assentos já reservados
    
    # Navegar para página de assentos
    Go To Seats Page
    
    # Tentar selecionar assento ocupado
    Try To Select Occupied Seat    B5
    Should Not Select Occupied Seat    B5

CT-005: Mostrar Subtotal Durante Seleção
    [Documentation]    Sistema mostra o subtotal à medida que os assentos são selecionados
    
    # Navegar para página de assentos
    Go To Seats Page
    
    # Limpar seleções anteriores
    Clear All Selected Seats
    
    # Selecionar um assento e verificar subtotal
    Select Available Seat    C1
    Should Show Subtotal    R$ 25,00
    
    # Selecionar segundo assento e verificar novo subtotal
    Select Available Seat    C2
    Should Show Subtotal    R$ 50,00
    
    # Desselecionar um assento e verificar subtotal atualizado
    Deselect Seat    C1
    Should Show Subtotal    R$ 25,00

CT-006: Prosseguir para Checkout com Assentos Selecionados
    [Documentation]    Usuário pode prosseguir para checkout após selecionar assentos
    
    # Navegar para página de assentos
    Go To Seats Page
    
    # Garantir que há assentos selecionados
    Select Available Seat    D1
    Select Available Seat    D2
    
    # Clicar em prosseguir
    Click Proceed To Checkout
    
    # Verificar redirecionamento para checkout
    Should Be On Checkout Page
    Should Display Selected Seats Summary

CT-007: Validar Seleção Mínima de Assentos
    [Documentation]    Sistema deve exigir pelo menos um assento selecionado
    
    # Navegar para página de assentos
    Go To Seats Page
    
    # Limpar todas as seleções
    Clear All Selected Seats
    
    # Tentar prosseguir sem assentos
    Click Proceed To Checkout
    
    # Verificar mensagem de erro
    Should Show Error Message    Selecione pelo menos um assento
    Should Remain On Seats Page
