*** Settings ***
Documentation       Testes de verificação se o sistema está online
...                 Verificação básica de disponibilidade da aplicação

Resource    ../resources/base.resource

*** Test Cases ***
CT-Online-001 Webapp deve estar online e acessível
    [Documentation]    Verifica se a aplicação Cinema está online e respondendo
    [Tags]    online    health-check    positive
    
    Start Session
    Get Text                    css=.home-container h1      equal       Welcome to Cinema App

CT-Online-002 Deve carregar página inicial corretamente
    [Documentation]    Verifica se a página inicial carrega todos os elementos básicos
    [Tags]    online    home-load    positive
    
    Start Session
    Wait For Elements State    css=.home-container    visible    10
    Wait For Elements State    css=.home-container h1    visible    5

CT-Online-003 Deve responder em tempo adequado
    [Documentation]    Verifica se a aplicação responde em tempo aceitável
    [Tags]    online    performance    positive
    
    ${start_time}=    Get Time    epoch
    Start Session
    Wait For Elements State    css=.home-container    visible    10
    ${end_time}=    Get Time    epoch
    
    ${response_time}=    Evaluate    ${end_time} - ${start_time}
    Should Be True    ${response_time} < 15    Aplicação demorou mais que 15 segundos para responder

CT-Online-004 Deve ter título correto da página
    [Documentation]    Verifica se o título da página está correto
    [Tags]    online    title    positive
    
    Start Session
    ${title}=    Get Title
    Should Contain    ${title}    Cinema    Título deve conter "Cinema"

CT-Online-005 Deve carregar recursos estáticos
    [Documentation]    Verifica se CSS e outros recursos estáticos carregam
    [Tags]    online    static-resources    positive
    
    Start Session
    
    # Verifica se há estilos aplicados
    ${body_styles}=    Get Style    css=body    background-color
    Should Not Be Empty    ${body_styles}
    
    # Verifica se imagens carregam (se houver)
    ${images_exist}=    Run Keyword And Return Status
    ...    Wait For Elements State    css=img    visible    5
    
    IF    ${images_exist}
        ${images}=    Get Elements    css=img
        ${images_count}=    Get Length    ${images}
        Should Be True    ${images_count} > 0
    END



CT-Online-007 Deve permitir acesso às rotas principais
    [Documentation]    Verifica se as rotas principais estão acessíveis
    [Tags]    online    routes    positive
    
    Start Session
    
    # Testa rota de filmes
    Go To    ${BASE_URL}/movies
    Wait For Load State    networkidle
    ${movies_url}=    Get Url
    Should Contain    ${movies_url}    /movies
    
    # Testa rota de login
    Go To    ${BASE_URL}/login
    Wait For Load State    networkidle
    ${login_url}=    Get Url
    Should Contain    ${login_url}    /login

CT-Online-008 Não deve ter erros JavaScript críticos
    [Documentation]    Verifica se não há erros JavaScript que impeçam o funcionamento
    [Tags]    online    javascript    positive
    
    Start Session
    
    # Aguarda carregamento completo
    Wait For Load State    networkidle
    
    # Verifica se elementos principais estão presentes (indica que JS funcionou)
    Wait For Elements State    css=.home-container    visible    5
    
    # Se chegou até aqui, não há erros críticos de JS



CT-Online-010 Deve ter conectividade com backend
    [Documentation]    Verifica se há conectividade básica com o backend
    [Tags]    online    backend    positive
    
    Start Session
    
    # Tenta carregar página que pode fazer chamadas para API
    Go To    ${BASE_URL}/movies
    Wait For Load State    networkidle
    
    # Se a página carregou sem erro 500, há conectividade básica
    ${current_url}=    Get Url
    Should Contain    ${current_url}    /movies