!function(e){var n={};function t(r){if(n[r])return n[r].exports;var a=n[r]={i:r,l:!1,exports:{}};return e[r].call(a.exports,a,a.exports,t),a.l=!0,a.exports}t.m=e,t.c=n,t.d=function(e,n,r){t.o(e,n)||Object.defineProperty(e,n,{enumerable:!0,get:r})},t.r=function(e){"undefined"!=typeof Symbol&&Symbol.toStringTag&&Object.defineProperty(e,Symbol.toStringTag,{value:"Module"}),Object.defineProperty(e,"__esModule",{value:!0})},t.t=function(e,n){if(1&n&&(e=t(e)),8&n)return e;if(4&n&&"object"==typeof e&&e&&e.__esModule)return e;var r=Object.create(null);if(t.r(r),Object.defineProperty(r,"default",{enumerable:!0,value:e}),2&n&&"string"!=typeof e)for(var a in e)t.d(r,a,function(n){return e[n]}.bind(null,a));return r},t.n=function(e){var n=e&&e.__esModule?function(){return e.default}:function(){return e};return t.d(n,"a",n),n},t.o=function(e,n){return Object.prototype.hasOwnProperty.call(e,n)},t.p="",t(t.s=0)}([function(e,n){window.onload=async()=>{if(window.getOfflineSigner&&window.keplr)if(window.keplr.experimentalSuggestChain)try{await window.keplr.experimentalSuggestChain({chainId:"akashnet-2",chainName:"Akash",rpc:"http://135.181.60.250:26657",rest:"http://135.181.60.250:1317",stakeCurrency:{coinDenom:"AKT",coinMinimalDenom:"uakt",coinDecimals:6,coinGeckoId:"akash-network"},bip44:{coinType:118},bech32Config:{bech32PrefixAccAddr:"akash",bech32PrefixAccPub:"akashpub",bech32PrefixValAddr:"akashvaloper",bech32PrefixValPub:"akashvaloperpub",bech32PrefixConsAddr:"akashvalopercons",bech32PrefixConsPub:"akashvaloperconspub"},currencies:[{coinDenom:"AKT",coinMinimalDenom:"uakt",coinDecimals:8,coinGeckoId:"akash-network"}],feeCurrencies:[{coinDenom:"AKT",coinMinimalDenom:"uakt",coinDecimals:6,coinGeckoId:"akash-network"}],gasPriceStep:{low:.0025,average:.003,high:.004},features:["stargate"]})}catch{alert("Failed to suggest the chain")}else alert("Please use the recent version of keplr extension");else alert("Please install keplr extension");await window.keplr.enable("akashnet-2");const e=window.getOfflineSigner("akashnet-2"),n=await e.getAccounts();document.getElementById("address").textContent=n[0].address}}]);