Feature: Product - Store

  Background:
    * def tienda = baseUrl
    * def cantidad = 2

    * def obtenerPrecio =
    """
    
function(valor) {
  var texto = ('' + valor).replace(/\s/g, '');
  var resultado = texto.match(/S\/(\d+(?:[.,]\d{2})?)/i);

  if (!resultado) {
    throw new Error('No se encontro un precio valido: ' + valor);
  }
  return parseFloat(resultado[1].replace(',', '.'));
}

    """

    * def redondear =
    """
    function(valor) {
      return Math.round(valor * 100) / 100;
    }
    """

  @login @regresion
  Scenario Outline: Validacion de autenticacion en la tienda

    Given driver tienda
    And waitFor("//body")
    And waitFor(selectors.loginLink).click()
    And waitFor(selectors.email)

    * def correoPrueba = caso == 'LOGIN_VALIDO' ? username : 'incorrecto@prueba.com'
    * def clavePrueba = caso == 'LOGIN_VALIDO' ? password : 'ClaveIncorrecta123'

    When input(selectors.email, correoPrueba)
    And input(selectors.password, clavePrueba)
    And waitFor(selectors.submitLogin).click()

    * def autenticacionEsperada = resultado == 'EXITOSO'

    * if (autenticacionEsperada) waitFor(selectors.account)
    * if (!autenticacionEsperada) waitFor(selectors.loginError)

    Then def autenticado = exists(selectors.account)
    And match autenticado == autenticacionEsperada

    * if (!autenticacionEsperada) karate.match(text(selectors.loginError).trim(), 'Error de autenticación.')

    * print 'Escenario:', caso
    * print 'Autenticacion esperada:', resultado
    * screenshot()

    Examples:
      | caso           | resultado |
      | LOGIN_VALIDO   | EXITOSO   |
      | LOGIN_INVALIDO | RECHAZADO |


  @productos @regresion
  Scenario: Validacion del precio de un producto

    Given driver tienda
    And waitFor("//body")

    And waitFor(selectors.loginLink).click()
    And waitFor(selectors.email)
    And input(selectors.email, username)
    And input(selectors.password, password)
    And waitFor(selectors.submitLogin).click()

    And waitFor(selectors.account)
    And match exists(selectors.account) == true

    When waitFor(selectors.categoryClothes).mouse()
    And waitFor(selectors.subcategoryMen).click()

    And match driver.url contains 'men'
    And waitFor(selectors.firstProduct)

    * screenshot()

    And waitFor(selectors.firstProduct).click()
    And waitFor(selectors.productPrice)

    * def precioTexto = text(selectors.productPrice)
    * def precioUnitario = obtenerPrecio(precioTexto)
    * assert precioUnitario > 0

    And waitFor(selectors.quantity)
    And clear(selectors.quantity)
    And input(selectors.quantity, '2')
    And waitFor(selectors.addToCart).click()

    Then waitFor(selectors.cartPopup)
    And waitFor(selectors.popupConfirmation)

    * def mensajePopup = text(selectors.popupConfirmation)
    And match mensajePopup contains 'Producto añadido correctamente'

    * def subtotalEsperado = redondear(precioUnitario * cantidad)

   * waitFor(selectors.popupSubtotal)
   * def subtotalPopup = obtenerPrecio(text(selectors.popupSubtotal))
    * def envioPopup = obtenerPrecio(text(selectors.popupShipping))
    * def totalPopup = obtenerPrecio(text(selectors.popupProductTotal))

    * def totalEsperado = redondear(subtotalEsperado + envioPopup)

    And match subtotalPopup == subtotalEsperado
    And match totalPopup == totalEsperado

    * print 'Precio unitario:', precioUnitario
    * print 'Cantidad:', cantidad
    * print 'Subtotal esperado:', subtotalEsperado
    * print 'Subtotal popup:', subtotalPopup
    * print 'Costo de envio:', envioPopup
    * print 'Total esperado:', totalEsperado
    * print 'Total popup:', totalPopup

    * screenshot()

    When waitFor(selectors.checkoutButton).click()

    Then waitFor(selectors.cartTitle)

    * def tituloCarrito = text(selectors.cartTitle)
    And match tituloCarrito == '#regex (?i).*(carrito|cart).*'

    * def subtotalCarrito = obtenerPrecio(text(selectors.cartProductsTotal))
    And match subtotalCarrito == subtotalEsperado

    * print 'Titulo carrito:', tituloCarrito
    * print 'Subtotal esperado:', subtotalEsperado
    * print 'Subtotal carrito:', subtotalCarrito

    * screenshot()


  @categoriaInvalida @regresion
  Scenario Outline: Validacion de categoria inexistente

    Given driver tienda
    And waitFor("//body")

    And waitFor(selectors.loginLink).click()
    And waitFor(selectors.email)

    And input(selectors.email, username)
    And input(selectors.password, password)
    And waitFor(selectors.submitLogin).click()

    And waitFor(selectors.account)

    When def xpathCategoria = "//ul[contains(@class,'top-menu')]//a[normalize-space()='" + categoria + "']"

    * def categoriaExiste = exists(xpathCategoria)

    Then match categoriaExiste == false

    * print 'Categoria evaluada:', categoria
    * print 'Categoria encontrada:', categoriaExiste

    * screenshot()

    Examples:
      | categoria |
      | Autos     |
