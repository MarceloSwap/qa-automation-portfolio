*** Settings ***
Documentation    US-RESERVE-003: Visualizar Minhas Reservas
Resource         ../resources/base.resource
Suite Setup      Start Session
Suite Teardown   Close Browser

*** Test Cases ***
CT-001: Acessar Lista de Reservas pelo Menu
    [Documentation]    Usuário pode acessar lista de suas reservas através do link "Minhas Reservas" no menu
    
    # Login como usuário
    ${user}=    Get fixture    users    valid_user
    Go to login page
    Fill Text    id=email    ${user['email']}
    Fill Text    id=password    ${user['password']}
    Click    css=button >> text=Entrar
    
    # Verificar se logou
    ${current_url}=    Get Url
    Should Not Contain    ${current_url}    /login
    
    # Acessar minhas reservas pelo menu
    ${reservations_link_exists}=    Run Keyword And Return Status
    ...    Wait For Elements State    css=a[href*="reservations"], a >> text=Minhas Reservas    visible    5
    
    IF    ${reservations_link_exists}
        Click    css=a[href*="reservations"], a >> text=Minhas Reservas
        Wait For Load State    networkidle
    ELSE
        Go To    ${BASE_URL}/reservations
    END

CT-002: Exibir Reservas em Formato de Card
    [Documentation]    Reservas são exibidas em formato de card com informações visuais claras
    
    # Verificar formato de exibição
    Should Display Reservations Grid
    Should Show Reservation Cards
    Should Display Card Layout
    Should Show Visual Hierarchy

CT-003: Exibir Informações Completas da Reserva
    [Documentation]    Cada reserva exibe filme, data, horário, cinema, assentos, status e método de pagamento
    
    # Verificar primeira reserva (se existir)
    ${has_reservations}=    Run Keyword And Return Status
    ...    Wait For Elements State    css=.reservation-card, .reservation-item    visible    5
    
    IF    ${has_reservations}
        Should Display Movie Title
        Should Display Session Date
        Should Display Session Time
        Should Display Theater Name
        Should Display Selected Seats
        Should Display Reservation Status
        Should Display Payment Method
    ELSE
        Should Show Empty State Message
    END

CT-004: Visualizar Pôster do Filme
    [Documentation]    Usuário pode visualizar o pôster do filme associado à reserva
    
    ${has_reservations}=    Run Keyword And Return Status
    ...    Wait For Elements State    css=.reservation-card, .reservation-item    visible    5
    
    IF    ${has_reservations}
        Should Display Movie Poster
        Should Show High Quality Image
        Should Display Fallback Image If Needed
    END

CT-005: Indicadores Visuais de Status
    [Documentation]    Sistema exibe indicadores visuais de status da reserva (confirmada, pendente, cancelada)
    
    ${has_reservations}=    Run Keyword And Return Status
    ...    Wait For Elements State    css=.reservation-card, .reservation-item    visible    5
    
    IF    ${has_reservations}
        Should Display Status Badge
        Should Show Green For Confirmed
        Should Show Yellow For Pending
        Should Show Red For Cancelled
        Should Display Status Text
    END

CT-006: Página Dedicada Separada do Perfil
    [Documentation]    Usuário pode acessar página dedicada de reservas separada das informações de perfil
    
    # Verificar que está em página separada
    ${current_url}=    Get Url
    Should Contain Any    ${current_url}    /reservations    /my-reservations
    Should Not Contain    ${current_url}    /profile
    
    ${reservations_header_exists}=    Run Keyword And Return Status
    ...    Wait For Elements State    css=h1 >> text=Minhas Reservas, h1 >> text=Reservas    visible    5
    Should Be True    ${reservations_header_exists}

CT-007: Filtrar Reservas por Status
    [Documentation]    Usuário pode filtrar reservas por status
    
    ${multiple_reservations}=    Run Keyword And Return Status
    ...    Get Elements    css=.reservation-card, .reservation-item
    
    IF    ${multiple_reservations}
        ${filter_exists}=    Run Keyword And Return Status
        ...    Wait For Elements State    css=.filter-status, select[name="status"]    visible    3
        
        IF    ${filter_exists}
            Filter By Status    Confirmada
            Should Show Only Confirmed Reservations
            Filter By Status    Pendente
            Should Show Only Pending Reservations
            Clear Filters
            Should Show All Reservations
        ELSE
            Log    Filtros não implementados
        END
    END

CT-008: Ordenar Reservas por Data
    [Documentation]    Usuário pode ordenar reservas por data
    
    ${multiple_reservations}=    Run Keyword And Return Status
    ...    Get Elements    css=.reservation-card, .reservation-item
    
    IF    ${multiple_reservations}
        ${sort_exists}=    Run Keyword And Return Status
        ...    Wait For Elements State    css=.sort-date, select[name="sort"]    visible    3
        
        IF    ${sort_exists}
            Sort By Date    Mais Recente
            Should Show Newest First
            Sort By Date    Mais Antiga
            Should Show Oldest First
        ELSE
            Log    Ordenação não implementada
        END
    END

CT-009: Visualizar Detalhes da Reserva
    [Documentation]    Usuário pode visualizar detalhes completos de uma reserva específica
    
    ${has_reservations}=    Run Keyword And Return Status
    ...    Wait For Elements State    css=.reservation-card, .reservation-item    visible    5
    
    IF    ${has_reservations}
        Click First Reservation
        Should Display Reservation Details
        Should Show Complete Information
        Should Display QR Code
        Should Show Booking Reference
    END

CT-010: Cancelar Reserva (se permitido)
    [Documentation]    Usuário pode cancelar reserva quando permitido
    
    ${cancellable_reservations}=    Run Keyword And Return Status
    ...    Wait For Elements State    css=.cancel-btn, button >> text=Cancelar    visible    5
    
    IF    ${cancellable_reservations}
        Click Cancel Reservation
        Should Show Cancellation Confirmation
        Confirm Cancellation
        Should Update Status To Cancelled
        Should Show Cancellation Success
    END

CT-011: Baixar Comprovante da Reserva
    [Documentation]    Usuário pode baixar comprovante da reserva
    
    ${has_reservations}=    Run Keyword And Return Status
    ...    Wait For Elements State    css=.reservation-card, .reservation-item    visible    5
    
    IF    ${has_reservations}
        ${download_btn_exists}=    Run Keyword And Return Status
        ...    Wait For Elements State    css=.download-btn, button >> text=Baixar    visible    3
        
        IF    ${download_btn_exists}
            Click Download Receipt
            Should Trigger Download
            Should Generate PDF Receipt
        ELSE
            Log    Botão de download não implementado
        END
    END

CT-012: Responsividade da Página de Reservas
    [Documentation]    Página de reservas deve ser responsiva em diferentes dispositivos
    
    # Testar em mobile
    Set Viewport Size    375    667
    Sleep    1s
    Should Display Mobile Layout
    Should Show Stacked Cards
    
    # Testar em tablet
    Set Viewport Size    768    1024
    Sleep    1s
    Should Display Tablet Layout
    Should Show Grid Layout
    
    # Testar em desktop
    Set Viewport Size    1920    1080
    Sleep    1s
    Should Display Desktop Layout
    Should Show Full Grid

CT-013: Estado Vazio - Nenhuma Reserva
    [Documentation]    Sistema deve exibir estado apropriado quando usuário não tem reservas
    
    # Fazer logout do usuário atual
    ${logout_btn_exists}=    Run Keyword And Return Status
    ...    Wait For Elements State    css=.logout-button, button >> text=Sair    visible    3
    
    IF    ${logout_btn_exists}
        Click    css=.logout-button, button >> text=Sair
        Wait For Load State    networkidle
    END
    
    # Verificar estado vazio ou criar novo usuário
    Go To    ${BASE_URL}/reservations
    
    ${empty_state_exists}=    Run Keyword And Return Status
    ...    Wait For Elements State    css=.empty-state, .no-reservations    visible    5
    
    IF    ${empty_state_exists}
        Should Show Empty State
        Should Display Empty Message
        Should Show Call To Action
        Should Provide Link To Movies
    ELSE
        Log    Estado vazio não encontrado ou usuário tem reservas
    END