const Configurations = {
    /*
     Adding this file on behalf of Zalak Prajapati.....
     This file can be used to override the configurations in devportal/source/src/defaultTheme.js
     ex. Uncomment the below section to enable the landingPage
     */

     custom: {
           landingPage: {
               active: true,
               carousel: {
                   active: true,
                   slides: [
                       {
                           src: '/site/public/images/landing/Company-Full-Bleed-Hero.png',

                           title: 'We Are Blackhawk Network.',
                           content:
                               'And we’re proud to be a global industry leader.',
                       },
                       {
                           src: '/site/public/images/landing/gift-card-logo.png',
                           title: 'Gift Cards, Prepaid Incentive Cards & More for Employers and Merchants',
                           content:
                           'We’re shaping the future of global branded payments.',



                       },
                       {
                           src: '/site/public/images/landing/Unique-Card-Catalog.png',
                           title: 'Optimize revenue and payment opportunities with gift cards',
                           content:
                               'Whether you sell your own gift cards or other brands’ gift cards, or you use Visa® and Mastercard® gift cards to distribute funds, we have over 1,000 options in our portfolio. Let us help you achieve your goals—and drive growth.',
                       },

                   ],
               },

               listByTag: {
                   active: true,
                   content: [
                       {
                           tag: 'finance',
                           title: 'Welcome to the Blackhawk Network API Developer Portal',
                           description:
                               'We offers online payment solutions and has more than 123 million customers worldwide. The WSO2 Finane API makes powerful functionality available to developers by exposing various features of our platform. Functionality includes but is not limited to invoice management, transaction processing and account management.',
                           maxCount: 5,
                       },
                       {
                           tag: 'finance',
                           title: 'Welcome to the Blackhawk Network API Developer Portal',
                           description:
                               'We offers online payment solutions and has more than 123 million customers worldwide. The WSO2 Finane API makes powerful functionality available to developers by exposing various features of our platform. Functionality includes but is not limited to invoice management, transaction processing and account management.',
                           maxCount: 5,
                       }
                   ],
               },


               parallax: {
                   active: true,
                   content: [
                       {
                           src: '/site/public/images/landing/B-Prepaid-Card-Catalog.png',
                           title: 'Commerce Solutions',
                           content:
                               'Blackhawk Network delivers branded payment programs to help meet today’s most challenging business objectives. We collaborate with our partners to innovate, translating market trends in branded payments to extend reach, build loyalty and increase revenue.',
                       },
                       {
                           src: '/site/public/images/landing/Unique-Card-Catalog.png',
                           title: 'Incentive Solutions',
                           content:
                               'When you sell gift cards that are exclusively ours, you give shoppers a specific reason to buy their gift cards from you. That’s why we are constantly developing new products with wide appeal—and availability only through our distribution partners.',
                       },
                       {
                           src: '/site/public/images/landing/Unique-Card-Catalog.png',
                           title: 'Incentive Solutions',
                           content:
                               'When you sell gift cards that are exclusively ours, you give shoppers a specific reason to buy their gift cards from you. That’s why we are constantly developing new products with wide appeal—and availability only through our distribution partners.',
                       },




                   ],
               },
           },

         appBar: {
             logo: '/site/public/images/bhn.svg', // You can set the url to an external image also ( ex: https://dummyimage.com/208x19/66aad1/ffffff&text=testlogo)
             logoHeight: 34,
             logoWidth: 'auto',
             background: '#ffffff',
             activeBackground: '#1c8426',
           },

           leftMenu: {
               position: 'vertical-left', // Sets the position of the left menu ( 'horizontal', 'vertical-left', 'vertical-right')
               style: 'icon left', //  other values ('icon top', 'icon left', 'no icon', 'no text')
               iconSize: 24,
               leftMenuTextStyle: 'uppercase',
               width: 180,
               background: '#1c8426',
               backgroundImage: '/site/public/images/leftMenuBack.png',
               leftMenuActive: '##1c8426',
               leftMenuActiveSubmenu: '#1c8426',
               activeBackground: '#1c8426',
               rootIconVisible: true,
               rootIconSize: 42,
               rootIconTextVisible: false,
               rootBackground: '#000',
           },
           tagCloud: {
               active: false,
               colorOptions: { // This is the Options object passed to TagCloud component of https://www.npmjs.com/package/react-tagcloud
                   luminosity: 'dark',
                   hue: 'blue',
               },
               leftMenu: { // These params will be applyed only if the style is 'fixed-left'
                   width: 200,
                   height: 'calc(100vh - 222px)',
                   background: '#1c8426',
                   color: '#000',
                   titleBackground: '#222',
                   sliderBackground: '#222',
                   sliderWidth: 25,
                   hasIcon: false,
               },
           },
           banner: {
               active: true, // make it true to display a banner image
               style: 'text', // 'can take 'image' or 'text'. If text it will display the 'banner.text' value else it will display the 'banner.image' value.
               image: '/site/public/images/landing/01.jpg',
               text: 'This is a very important announcement',
               color: '#ffffff',
               background: '#e08a00',
               padding: 20,
               margin: 0,
               fontSize: 18,
               textAlign: 'center',
           },
           footer: {

               text: '©2022 Blackhawk Network Holdings, Inc. All Rights Reserved. Terms of Use | Cookie Policy | Privacy Policy | Partner Disclosure',
               background: '#000',
               color: '#ffffff',
               height: 50,
           },

           title: {
               prefix: '[BHN]',
               sufix: '- Devportal-BHN',
           },

     },

     overrides:{
       MuiButton:{
         root:{
           background:'linear-gradient(#1c8426, #1c8426);',
           color:'white',
         },
         text:{
           background:'inherit',
           color:'white',
         },
       },
     },


};