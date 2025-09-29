*** Settings ***
Documentation        Cenários de tentativa de cadastro com senha muito curta (template de teste a nível de suite) CT005

Resource          ../resources/base.resource

Test Setup        Start Session
Test Teardown     Take Screenshot

Test Template     Short password CT005

*** Test Cases ***
Não deve cadastrar com senha de 1 dígito     1
Não deve cadastrar com senha de 2 dígitos    12
Não deve cadastrar com senha de 3 dígitos    123
Não deve cadastrar com senha de 4 dígitos    1234
Não deve cadastrar com senha de 5 dígitos    12345


*** Keywords ***
Short password CT005
    [Arguments]    ${short_pass}
    ${user}        Create Dictionary
    ...            name=TestCT005
    ...            email=ct005@mail.com
    ...            password=${short_pass}

    Go to signup page
    Submit signup form        ${user}

    Alert should be    Informe uma senha com pelo menos 6 digitos