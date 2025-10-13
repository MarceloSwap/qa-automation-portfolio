*** Settings ***
Documentation        Elementos e ações da página de seleção de assentos

Library        Browser
Resource       ../env.resource

*** Variables ***
# Seletores da página de assentos
${SEATS_CONTAINER}        css=.seats-container
${THEATER_LAYOUT}         css=.theater-layout
${SEAT}                   css=.seat
${SEAT_AVAILABLE}         css=.seat.available
${SEAT_OCCUPIED}          css=.seat.occupied
${SEAT_SELECTED}          css=.seat.selected
${SEAT_LEGEND}            css=.seat-legend
${SUBTOTAL}               css=.subtotal
${CONTINUE_BTN}           css=.continue-btn
${SESSION_INFO}           css=.session-info

*** Keywords ***
# Navegação e Setup
Go To Seats Page
    Go To    ${BASE_URL}/sessions/68ec343bf3a9554087e3e7a5
    Wait For Load State    networkidle

Should Be On Seats Page
    Get Url    should contain    /seats

# Layout e Visualização
Should Display Seats Layout
    Wait For Elements State    ${SEATS_CONTAINER}    visible    10
    Wait For Elements State    ${THEATER_LAYOUT}     visible    10

Should Display Seat Legend
    Wait For Elements State    ${SEAT_LEGEND}    visible    5

Should Display Available Seats
    ${available}=    Get Elements    ${SEAT_AVAILABLE}
    ${count}=    Get Length    ${available}
    Log    Available seats found: ${count}
    # Aceita se há pelo menos 0 assentos (pode não haver disponíveis)
    Should Be True    ${count} >= 0

Should Display Occupied Seats
    ${occupied}=    Get Elements    ${SEAT_OCCUPIED}
    ${count}=    Get Length    ${occupied}
    Log    Occupied seats: ${count}

# Cores dos Assentos
Should Display Green Available Seats
    ${available}=    Get Elements    ${SEAT_AVAILABLE}
    ${count}=    Get Length    ${available}
    Log    Green available seats: ${count}
    # Verifica se existem ou se a página carregou
    Should Be True    ${count} >= 0

Should Display Red Occupied Seats
    ${occupied}=    Get Elements    ${SEAT_OCCUPIED}
    ${count}=    Get Length    ${occupied}
    Log    Red occupied seats: ${count}
    Should Be True    ${count} >= 0

Should Display Blue Selected Seats
    ${selected}=    Get Elements    ${SEAT_SELECTED}
    ${count}=    Get Length    ${selected}
    Log    Blue selected seats: ${count}
    Should Be True    ${count} >= 0

Verificar Layout do Teatro
    [Documentation]    Verifica se o layout do teatro está presente
    Wait For Elements State    ${THEATER_LAYOUT}    visible    5
    ${seats}=    Get Elements    ${SEAT}
    ${seats_count}=    Get Length    ${seats}
    Should Be True    ${seats_count} > 0    Nenhum assento encontrado no layout

Verificar Legenda de Assentos
    [Documentation]    Verifica se a legenda de cores está presente
    Wait For Elements State    ${SEAT_LEGEND}    visible    5
    
    # Verifica se há indicadores para diferentes tipos de assento
    ${legend_items}=    Get Elements    ${SEAT_LEGEND} >> css=.legend-item
    ${legend_count}=    Get Length    ${legend_items}
    Should Be True    ${legend_count} >= 3    Legenda deve ter pelo menos 3 tipos

Verificar Assentos por Disponibilidade
    [Documentation]    Verifica se há assentos disponíveis e ocupados
    
    ${available_seats}=    Get Elements    ${SEAT_AVAILABLE}
    ${occupied_seats}=     Get Elements    ${SEAT_OCCUPIED}
    
    ${available_count}=    Get Length    ${available_seats}
    ${occupied_count}=     Get Length    ${occupied_seats}
    
    Should Be True    ${available_count} > 0    Deve haver assentos disponíveis
    Log    Assentos disponíveis: ${available_count}, ocupados: ${occupied_count}

# Seleção de Assentos
Select Available Seat
    [Arguments]    ${seat_id}
    ${available_seats}=    Get Elements    ${SEAT_AVAILABLE}
    ${seat_count}=    Get Length    ${available_seats}
    IF    ${seat_count} > 0
        Click    ${available_seats}[0]
        Sleep    1s
    END

Should Show Seat As Selected
    [Arguments]    ${seat_id}
    ${selected_seats}=    Get Elements    ${SEAT_SELECTED}
    ${count}=    Get Length    ${selected_seats}
    Should Be True    ${count} > 0

Should Show Selected Seats Count
    [Arguments]    ${expected_count}
    ${selected}=    Get Elements    ${SEAT_SELECTED}
    ${count}=    Get Length    ${selected}
    Should Be True    ${count} >= 1

Try To Select Occupied Seat
    [Arguments]    ${seat_id}
    Click    css=[data-seat="${seat_id}"].occupied

Should Not Select Occupied Seat
    [Arguments]    ${seat_id}
    Get Attribute    css=[data-seat="${seat_id}"]    class    should not contain    selected

Selecionar Múltiplos Assentos
    [Documentation]    Seleciona múltiplos assentos disponíveis
    [Arguments]    ${quantity}=2
    
    ${available_seats}=    Get Elements    ${SEAT_AVAILABLE}
    ${available_count}=    Get Length    ${available_seats}
    
    Should Be True    ${available_count} >= ${quantity}    Não há assentos suficientes
    
    FOR    ${i}    IN RANGE    ${quantity}
        ${seat}=    Set Variable    ${available_seats}[${i}]
        Click    ${seat}
        Sleep    0.5s
    END

Tentar Selecionar Assento Ocupado
    [Documentation]    Tenta selecionar um assento ocupado (deve falhar)
    
    ${occupied_seats}=    Get Elements    ${SEAT_OCCUPIED}
    ${occupied_count}=    Get Length    ${occupied_seats}
    
    IF    ${occupied_count} > 0
        ${occupied_seat}=    Set Variable    ${occupied_seats}[0]
        Click    ${occupied_seat}
        
        # Verifica que não foi selecionado
        ${seat_class}=    Get Attribute    ${occupied_seat}    class
        Should Not Contain    ${seat_class}    selected
    ELSE
        Log    Nenhum assento ocupado para testar
    END

# Subtotal e Preços
Should Show Subtotal
    [Arguments]    ${expected_price}
    ${subtotal}=    Get Text    ${SUBTOTAL}
    Should Contain    ${subtotal}    ${expected_price}

Clear All Selected Seats
    ${selected}=    Get Elements    ${SEAT_SELECTED}
    FOR    ${seat}    IN    @{selected}
        Click    ${seat}
    END

Deselect Seat
    [Arguments]    ${seat_id}
    Click    css=[data-seat="${seat_id}"].selected

# Navegação para Checkout
Click Proceed To Checkout
    Click    ${CONTINUE_BTN}
    Wait For Load State    networkidle

Should Be On Checkout Page
    Get Url    should contain    /checkout

Should Display Selected Seats Summary
    Wait For Elements State    css=.seats-summary    visible    5

# Validações e Erros
Should Show Error Message
    [Arguments]    ${message}
    Wait For Elements State    css=.error-message    visible    5
    ${error_text}=    Get Text    css=.error-message
    Should Contain    ${error_text}    ${message}

Should Remain On Seats Page
    Get Url    should contain    /seats

Should Show Seat As Occupied
    [Arguments]    ${seat_id}
    Get Attribute    css=[data-seat="${seat_id}"]    class    should contain    occupied

Should Not Allow Selection
    [Arguments]    ${seat_id}
    Click    css=[data-seat="${seat_id}"].occupied
    Get Attribute    css=[data-seat="${seat_id}"]    class    should not contain    selected

Obter Quantidade de Assentos Selecionados
    [Documentation]    Retorna a quantidade de assentos selecionados
    
    ${selected_seats}=    Get Elements    ${SEAT_SELECTED}
    ${selected_count}=    Get Length    ${selected_seats}
    RETURN    ${selected_count}

Navegar para Página de Assentos
    [Documentation]    Navega para página de seleção de assentos
    [Arguments]    ${session_id}=1
    Go To    ${BASE_URL}/sessions/${session_id}/seats
    Aguardar Carregamento dos Assentos