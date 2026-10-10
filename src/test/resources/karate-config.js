
function fn() {

    var config = {
        baseUrl: 'https://qalab.bensg.com/store/pe/',
        username: karate.properties['store.user'] || '',
        password: karate.properties['store.password'] || '',
        selectors: {
            loginLink: "(//a[contains(normalize-space(.), 'Iniciar sesión')])[1]",
            email: "//input[@name='email']",
            password: "//input[@name='password']",
            submitLogin: "//button[@id='submit-login']",
            account: "//a[contains(@class,'account')]",
            loginError: "//li[contains(@class,'alert-danger')]",
           
            categoryClothes: "(//ul[contains(@class,'top-menu')]//a[contains(translate(normalize-space(.), 'abcdefghijklmnopqrstuvwxyz', 'ABCDEFGHIJKLMNOPQRSTUVWXYZ'), 'CLOTHES')])[1]",
            subcategoryMen: "(//ul[contains(@class,'top-menu')]//a[contains(translate(normalize-space(.), 'abcdefghijklmnopqrstuvwxyz', 'ABCDEFGHIJKLMNOPQRSTUVWXYZ'), 'MEN')])[1]",
            firstProduct: "(//article[contains(@class,'product-miniature')]//a[contains(@class,'thumbnail')])[1]",
            quantity: "//input[@id='quantity_wanted']",
            addToCart: "//button[@data-button-action='add-to-cart']",
            cartPopup: "//div[@id='blockcart-modal']",
            
            firstProduct: "(//article[contains(@class,'product-miniature')]//a[contains(@class,'thumbnail')])[1]",
            productPrice: "//div[contains(@class,'current-price')]//span[@content or @itemprop='price']",
            quantity: "//input[@id='quantity_wanted']",
            addToCart: "//button[@data-button-action='add-to-cart']",
            cartPopup: "//div[@id='blockcart-modal']",
            popupConfirmation: "//div[@id='blockcart-modal']//h4",
            popupProductTotal: "(//div[@id='blockcart-modal']//div[contains(@class,'cart-content')]//p[contains(@class,'product-total')]//span[contains(@class,'value')])[1]",
            checkoutButton: "//div[@id='blockcart-modal']//a[contains(@class,'btn-primary')]",
            cartTitle: "//h1[contains(@class,'h1')]",
            cartProductsTotal: "//div[contains(@class,'cart-summary-line') and contains(@id,'cart-subtotal-products')]//span[contains(@class,'value')]",
            popupSubtotal: "(//div[@id='blockcart-modal']//div[contains(@class,'cart-content')]//p)[2]",
            popupShipping: "(//div[@id='blockcart-modal']//div[contains(@class,'cart-content')]//p)[3]",
            popupProductTotal: "(//div[@id='blockcart-modal']//div[contains(@class,'cart-content')]//p)[4]",
        }
    };

    var esGitHub = karate.properties['ci'] == 'true';

var rutaDriver = esGitHub
  ? karate.properties['webdriver.path']
  : 'C:/tools/chromedriver/chromedriver.exe';

var opcionesDriver = {
  type: 'chromedriver',
  executable: rutaDriver,
  headless: esGitHub
};

if (esGitHub) {
  opcionesDriver.webDriverSession = {
    capabilities: {
      alwaysMatch: {
        browserName: 'chrome',
        'goog:chromeOptions': {
           binary: karate.properties['chrome.path'],
          args: [
            '--headless=new',
            '--no-sandbox',
            '--disable-dev-shm-usage',
            '--window-size=1920,1080'
          ]
        }
      }
    }
  };
}

karate.configure('driver', opcionesDriver);

    karate.configure('retry', {
        count: 10,
        interval: 1000
    });

    return config;
}
