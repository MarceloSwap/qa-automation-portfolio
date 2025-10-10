*** Settings ***
Documentation        Elementos e ações da página de reservas

Library        Browser
Resource       ../env.resource

*** Variables ***
# Seletores da página de reservas
${RESERVATIONS_CONTAINER}    css=.reservations-container
${RESERVATION_CARD}          css=.reservation-card
${MOVIE_POSTER}              css=.movie-poster
${MOVIE_TITLE}               css=.movie-title
${RESERVATION_DATE}          css=.reservation-date
${RESERVATION_TIME}          css=.reservation-time
${CINEMA_NAME}               css=.cinema-name
${RESERVED_SEATS}            css=.reserved-seats
${RESERVATION_STATUS}        css=.reservation-status
${PAYMENT_METHOD}            css=.payment-method
${NO_RESERVATIONS_MESSAGE}   css=.no-reservations-message
${STATUS_CONFIRMED}          css=.status-confirmed
${STATUS_PENDING}            css=.status-pending
${STATUS_CANCELLED}          css=.status-cancelled

*** Keywords ***
Aguardar Carregamento das Reservas
    [Documentation]    Aguarda o carregamento da página de reservas
    Wait For Elements State    ${RESERVATIONS_CONTAINER}    visible    10
    Wait For Load State        networkidle

Verificar Cards de Reservas
    [Documentation]    Verifica se há cards de reservas na página
    ${reservation_cards}=    Get Elements    ${RESERVATION_CARD}
    ${cards_count}=    Get Length    ${reservation_cards}
    
    IF    ${cards_count} > 0
        Log    Encontradas ${cards_count} reservas
        RETURN    ${reservation_cards}
    ELSE
        ${no_reservations_exists}=    Run Keyword And Return Status
        ...    Wait For Elements State    ${NO_RESERVATIONS_MESSAGE}    visible    5
        
        IF    ${no_reservations_exists}
            Log    Nenhuma reserva encontrada - mensagem exibida
        END
        
        RETURN    @{EMPTY}
    END

Verificar Elementos do Card de Reserva
    [Documentation]    Verifica elementos de um card de reserva específico
    [Arguments]    ${card_index}=0
    
    ${reservation_cards}=    Get Elements    ${RESERVATION_CARD}
    ${card}=    Set Variable    ${reservation_cards}[${card_index}]
    
    # Verifica pôster do filme
    ${poster_exists}=    Run Keyword And Return Status
    ...    Wait For Elements State    ${card} >> ${MOVIE_POSTER}    visible    2
    
    IF    ${poster_exists}
        ${poster_src}=    Get Attribute    ${card} >> ${MOVIE_POSTER}    src
        Should Not Be Empty    ${poster_src}
    END
    
    # Verifica título do filme
    Wait For Elements State    ${card} >> ${MOVIE_TITLE}    visible    5
    ${title}=    Get Text    ${card} >> ${MOVIE_TITLE}
    Should Not Be Empty    ${title}
    
    # Verifica data da reserva
    Wait For Elements State    ${card} >> ${RESERVATION_DATE}    visible    5
    ${date}=    Get Text    ${card} >> ${RESERVATION_DATE}
    Should Not Be Empty    ${date}
    
    # Verifica horário
    Wait For Elements State    ${card} >> ${RESERVATION_TIME}    visible    5
    ${time}=    Get Text    ${card} >> ${RESERVATION_TIME}
    Should Not Be Empty    ${time}
    
    # Verifica cinema
    Wait For Elements State    ${card} >> ${CINEMA_NAME}    visible    5
    ${cinema}=    Get Text    ${card} >> ${CINEMA_NAME}
    Should Not Be Empty    ${cinema}
    
    # Verifica assentos
    Wait For Elements State    ${card} >> ${RESERVED_SEATS}    visible    5
    ${seats}=    Get Text    ${card} >> ${RESERVED_SEATS}
    Should Not Be Empty    ${seats}
    
    # Verifica status
    Wait For Elements State    ${card} >> ${RESERVATION_STATUS}    visible    5
    ${status}=    Get Text    ${card} >> ${RESERVATION_STATUS}
    Should Not Be Empty    ${status}
    
    # Verifica método de pagamento
    ${payment_exists}=    Run Keyword And Return Status
    ...    Wait For Elements State    ${card} >> ${PAYMENT_METHOD}    visible    2
    
    IF    ${payment_exists}
        ${payment}=    Get Text    ${card} >> ${PAYMENT_METHOD}
        Should Not Be Empty    ${payment}
    END

Verificar Status Visual das Reservas
    [Documentation]    Verifica se os indicadores visuais de status estão presentes
    
    ${confirmed_reservations}=    Get Elements    ${STATUS_CONFIRMED}
    ${pending_reservations}=      Get Elements    ${STATUS_PENDING}
    ${cancelled_reservations}=    Get Elements    ${STATUS_CANCELLED}
    
    ${confirmed_count}=    Get Length    ${confirmed_reservations}
    ${pending_count}=      Get Length    ${pending_reservations}
    ${cancelled_count}=    Get Length    ${cancelled_reservations}
    
    ${total_status}=    Evaluate    ${confirmed_count} + ${pending_count} + ${cancelled_count}
    Should Be True    ${total_status} > 0    Nenhum indicador de status encontrado
    
    Log    Reservas confirmadas: ${confirmed_count}, pendentes: ${pending_count}, canceladas: ${cancelled_count}

Filtrar Reservas por Status
    [Documentation]    Filtra reservas por status específico
    [Arguments]    ${status}=confirmed
    
    IF    '${status}' == 'confirmed'
        ${status_cards}=    Get Elements    ${STATUS_CONFIRMED}
    ELSE IF    '${status}' == 'pending'
        ${status_cards}=    Get Elements    ${STATUS_PENDING}
    ELSE IF    '${status}' == 'cancelled'
        ${status_cards}=    Get Elements    ${STATUS_CANCELLED}
    ELSE
        Fail    Status inválido: ${status}
    END
    
    ${count}=    Get Length    ${status_cards}
    RETURN    ${count}

Verificar Acesso via Menu
    [Documentation]    Verifica se é possível acessar reservas via menu
    
    ${menu_link_exists}=    Run Keyword And Return Status
    ...    Wait For Elements State    css=a[href="/reservations"]    visible    5
    
    IF    ${menu_link_exists}
        Click    css=a[href="/reservations"]
        Aguardar Carregamento das Reservas
    ELSE
        Fail    Link 'Minhas Reservas' não encontrado no menu
    END

Navegar para Página de Reservas
    [Documentation]    Navega para página de reservas
    Go To    ${BASE_URL}/reservations
    Aguardar Carregamento das Reservas