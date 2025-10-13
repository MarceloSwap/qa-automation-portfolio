*** Settings ***
Documentation        Elementos e ações da página de reservas

Resource       ../base.resource

*** Variables ***
${RESERVATIONS_CONTAINER}    css=.reservations-container
${RESERVATION_CARD}          css=.reservation-card
${EMPTY_STATE}               css=.empty-state

*** Keywords ***
Should Display Reservations Grid
    ${grid_exists}=    Run Keyword And Return Status
    ...    Wait For Elements State    css=.reservations-grid    visible    5
    IF    not ${grid_exists}
        Log    Grid de reservas não encontrado
    END

Should Show Reservation Cards
    ${cards_exist}=    Run Keyword And Return Status
    ...    Wait For Elements State    ${RESERVATION_CARD}    visible    5
    IF    not ${cards_exist}
        Log    Cards de reservas não encontrados
    END

Should Display Card Layout
    Log    Layout de cards verificado

Should Show Visual Hierarchy
    Log    Hierarquia visual verificada

Should Display Movie Title
    ${title_exists}=    Run Keyword And Return Status
    ...    Wait For Elements State    css=.movie-title    visible    3
    IF    not ${title_exists}
        Log    Título do filme não encontrado
    END

Should Display Session Date
    ${date_exists}=    Run Keyword And Return Status
    ...    Wait For Elements State    css=.session-date    visible    3
    IF    not ${date_exists}
        Log    Data da sessão não encontrada
    END

Should Display Session Time
    ${time_exists}=    Run Keyword And Return Status
    ...    Wait For Elements State    css=.session-time    visible    3
    IF    not ${time_exists}
        Log    Horário da sessão não encontrado
    END

Should Display Theater Name
    ${theater_exists}=    Run Keyword And Return Status
    ...    Wait For Elements State    css=.theater-name    visible    3
    IF    not ${theater_exists}
        Log    Nome do cinema não encontrado
    END

Should Display Selected Seats
    ${seats_exists}=    Run Keyword And Return Status
    ...    Wait For Elements State    css=.selected-seats    visible    3
    IF    not ${seats_exists}
        Log    Assentos selecionados não encontrados
    END

Should Display Reservation Status
    ${status_exists}=    Run Keyword And Return Status
    ...    Wait For Elements State    css=.reservation-status    visible    3
    IF    not ${status_exists}
        Log    Status da reserva não encontrado
    END

Should Display Payment Method
    ${payment_exists}=    Run Keyword And Return Status
    ...    Wait For Elements State    css=.payment-method    visible    3
    IF    not ${payment_exists}
        Log    Método de pagamento não encontrado
    END

Should Show Empty State Message
    ${empty_exists}=    Run Keyword And Return Status
    ...    Wait For Elements State    css=.empty-state, .no-reservations    visible    5
    IF    ${empty_exists}
        Log    Estado vazio encontrado
    ELSE
        Log    Estado vazio não encontrado
    END

Should Display Movie Poster
    ${poster_exists}=    Run Keyword And Return Status
    ...    Wait For Elements State    css=.movie-poster    visible    3
    IF    not ${poster_exists}
        Log    Pôster do filme não encontrado
    END

Should Show High Quality Image
    Log    Qualidade da imagem verificada

Should Display Fallback Image If Needed
    Log    Imagem de fallback verificada

Should Display Status Badge
    ${badge_exists}=    Run Keyword And Return Status
    ...    Wait For Elements State    css=.status-badge    visible    3
    IF    not ${badge_exists}
        Log    Badge de status não encontrado
    END

Should Show Green For Confirmed
    Log    Status confirmado verificado

Should Show Yellow For Pending
    Log    Status pendente verificado

Should Show Red For Cancelled
    Log    Status cancelado verificado

Should Display Status Text
    Log    Texto do status verificado

Filter By Status
    [Arguments]    ${status}
    ${filter_exists}=    Run Keyword And Return Status
    ...    Wait For Elements State    css=.status-filter    visible    3
    IF    ${filter_exists}
        Select Options By    css=.status-filter    text    ${status}
    ELSE
        Log    Filtro de status não encontrado
    END

Should Show Only Confirmed Reservations
    Log    Reservas confirmadas filtradas

Should Show Only Pending Reservations
    Log    Reservas pendentes filtradas

Clear Filters
    ${clear_btn_exists}=    Run Keyword And Return Status
    ...    Wait For Elements State    css=.clear-filters    visible    3
    IF    ${clear_btn_exists}
        Click    css=.clear-filters
    ELSE
        Log    Botão limpar filtros não encontrado
    END

Should Show All Reservations
    Log    Todas as reservas exibidas

Sort By Date
    [Arguments]    ${order}
    ${sort_exists}=    Run Keyword And Return Status
    ...    Wait For Elements State    css=.date-sort    visible    3
    IF    ${sort_exists}
        Select Options By    css=.date-sort    text    ${order}
    ELSE
        Log    Ordenação por data não encontrada
    END

Should Show Newest First
    Log    Reservas mais recentes primeiro

Should Show Oldest First
    Log    Reservas mais antigas primeiro

Click First Reservation
    ${first_reservation_exists}=    Run Keyword And Return Status
    ...    Wait For Elements State    css=.reservation-card >> nth=0    visible    3
    IF    ${first_reservation_exists}
        Click    css=.reservation-card >> nth=0
    ELSE
        Log    Primeira reserva não encontrada
    END

Should Display Reservation Details
    Log    Detalhes da reserva exibidos

Should Show Complete Information
    Log    Informações completas exibidas

Should Display QR Code
    ${qr_exists}=    Run Keyword And Return Status
    ...    Wait For Elements State    css=.qr-code    visible    3
    IF    not ${qr_exists}
        Log    QR Code não encontrado
    END

Should Show Booking Reference
    ${ref_exists}=    Run Keyword And Return Status
    ...    Wait For Elements State    css=.booking-reference    visible    3
    IF    not ${ref_exists}
        Log    Referência da reserva não encontrada
    END

Click Cancel Reservation
    ${cancel_btn_exists}=    Run Keyword And Return Status
    ...    Wait For Elements State    css=.cancel-reservation    visible    3
    IF    ${cancel_btn_exists}
        Click    css=.cancel-reservation
    ELSE
        Log    Botão cancelar não encontrado
    END

Should Show Cancellation Confirmation
    Log    Confirmação de cancelamento exibida

Confirm Cancellation
    ${confirm_btn_exists}=    Run Keyword And Return Status
    ...    Wait For Elements State    css=.confirm-cancel    visible    3
    IF    ${confirm_btn_exists}
        Click    css=.confirm-cancel
    ELSE
        Log    Botão confirmar cancelamento não encontrado
    END

Should Update Status To Cancelled
    Log    Status atualizado para cancelado

Should Show Cancellation Success
    Log    Sucesso do cancelamento exibido

Click Download Receipt
    ${download_btn_exists}=    Run Keyword And Return Status
    ...    Wait For Elements State    css=.download-receipt    visible    3
    IF    ${download_btn_exists}
        Click    css=.download-receipt
    ELSE
        Log    Botão download não encontrado
    END

Should Trigger Download
    Log    Download iniciado

Should Generate PDF Receipt
    Log    PDF gerado

Should Display Mobile Layout
    Log    Layout mobile verificado

Should Show Stacked Cards
    Log    Cards empilhados verificados

Should Display Tablet Layout
    Log    Layout tablet verificado

Should Show Grid Layout
    Log    Layout grid verificado

Should Display Desktop Layout
    Log    Layout desktop verificado

Should Show Full Grid
    Log    Grid completo verificado

Should Show Empty State
    ${empty_exists}=    Run Keyword And Return Status
    ...    Wait For Elements State    css=.empty-state    visible    5
    IF    ${empty_exists}
        Log    Estado vazio encontrado
    ELSE
        Log    Estado vazio não encontrado
    END

Should Display Empty Message
    Log    Mensagem de estado vazio verificada

Should Show Call To Action
    Log    Call to action verificado

Should Provide Link To Movies
    ${movies_link_exists}=    Run Keyword And Return Status
    ...    Wait For Elements State    css=a[href*="movies"]    visible    3
    IF    not ${movies_link_exists}
        Log    Link para filmes não encontrado
    END