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
Aguardar Carregamento dos Assentos
    [Documentation]    Aguarda o carregamento da página de assentos
    Wait For Elements State    ${SEATS_CONTAINER}    visible    10
    Wait For Elements State    ${THEATER_LAYOUT}     visible    10
    Wait For Load State        networkidle

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

Selecionar Assento Disponível
    [Documentation]    Seleciona um assento disponível
    [Arguments]    ${seat_index}=0
    
    ${available_seats}=    Get Elements    ${SEAT_AVAILABLE}
    ${seat}=    Set Variable    ${available_seats}[${seat_index}]
    Click    ${seat}
    
    # Verifica se o assento foi selecionado
    Wait For Elements State    ${seat}    visible    2
    ${seat_class}=    Get Attribute    ${seat}    class
    Should Contain    ${seat_class}    selected

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

Verificar Subtotal Atualizado
    [Documentation]    Verifica se o subtotal é atualizado conforme seleção
    
    Wait For Elements State    ${SUBTOTAL}    visible    5
    ${subtotal_text}=    Get Text    ${SUBTOTAL}
    Should Not Be Empty    ${subtotal_text}
    Should Contain Any    ${subtotal_text}    R$    $    €

Continuar para Checkout
    [Documentation]    Clica no botão para continuar para checkout
    
    ${selected_seats}=    Get Elements    ${SEAT_SELECTED}
    ${selected_count}=    Get Length    ${selected_seats}
    Should Be True    ${selected_count} > 0    Nenhum assento selecionado
    
    Click    ${CONTINUE_BTN}
    Wait For Load State    networkidle

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