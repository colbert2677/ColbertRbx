"use strict";(self.webpackChunkdocs=self.webpackChunkdocs||[]).push([[374],{3905:(e,t,n)=>{n.d(t,{Zo:()=>u,kt:()=>d});var r=n(7294);function a(e,t,n){return t in e?Object.defineProperty(e,t,{value:n,enumerable:!0,configurable:!0,writable:!0}):e[t]=n,e}function o(e,t){var n=Object.keys(e);if(Object.getOwnPropertySymbols){var r=Object.getOwnPropertySymbols(e);t&&(r=r.filter((function(t){return Object.getOwnPropertyDescriptor(e,t).enumerable}))),n.push.apply(n,r)}return n}function l(e){for(var t=1;t<arguments.length;t++){var n=null!=arguments[t]?arguments[t]:{};t%2?o(Object(n),!0).forEach((function(t){a(e,t,n[t])})):Object.getOwnPropertyDescriptors?Object.defineProperties(e,Object.getOwnPropertyDescriptors(n)):o(Object(n)).forEach((function(t){Object.defineProperty(e,t,Object.getOwnPropertyDescriptor(n,t))}))}return e}function c(e,t){if(null==e)return{};var n,r,a=function(e,t){if(null==e)return{};var n,r,a={},o=Object.keys(e);for(r=0;r<o.length;r++)n=o[r],t.indexOf(n)>=0||(a[n]=e[n]);return a}(e,t);if(Object.getOwnPropertySymbols){var o=Object.getOwnPropertySymbols(e);for(r=0;r<o.length;r++)n=o[r],t.indexOf(n)>=0||Object.prototype.propertyIsEnumerable.call(e,n)&&(a[n]=e[n])}return a}var i=r.createContext({}),s=function(e){var t=r.useContext(i),n=t;return e&&(n="function"==typeof e?e(t):l(l({},t),e)),n},u=function(e){var t=s(e.components);return r.createElement(i.Provider,{value:t},e.children)},m="mdxType",p={inlineCode:"code",wrapper:function(e){var t=e.children;return r.createElement(r.Fragment,{},t)}},f=r.forwardRef((function(e,t){var n=e.components,a=e.mdxType,o=e.originalType,i=e.parentName,u=c(e,["components","mdxType","originalType","parentName"]),m=s(n),f=a,d=m["".concat(i,".").concat(f)]||m[f]||p[f]||o;return n?r.createElement(d,l(l({ref:t},u),{},{components:n})):r.createElement(d,l({ref:t},u))}));function d(e,t){var n=arguments,a=t&&t.mdxType;if("string"==typeof e||a){var o=n.length,l=new Array(o);l[0]=f;var c={};for(var i in t)hasOwnProperty.call(t,i)&&(c[i]=t[i]);c.originalType=e,c[m]="string"==typeof e?e:a,l[1]=c;for(var s=2;s<o;s++)l[s]=n[s];return r.createElement.apply(null,l)}return r.createElement.apply(null,n)}f.displayName="MDXCreateElement"},4167:(e,t,n)=>{n.r(t),n.d(t,{HomepageFeatures:()=>g,default:()=>y});var r=n(7462),a=n(7294),o=n(3905);const l={toc:[]},c="wrapper";function i(e){let{components:t,...n}=e;return(0,o.kt)(c,(0,r.Z)({},l,n,{components:t,mdxType:"MDXLayout"}),(0,o.kt)("h1",{id:"colbertrbx"},"ColbertRbx"),(0,o.kt)("p",null,"Collection of public code resources written or modified for Roblox. This is a heavily experimental repository primarily intended for my own use but also available for others to use as well. As ColbertRbx is my first dip into the open source contribution space, there might be a lot of bad practices including this mono-repository with all packages available as directories rather than separate repositories, moonwave-incompatible naming, bad use of semver, some unfinished works rather than release-ready packages (check ReplicationUtils as an example of how I ended up publishing a few versions with minimal changes between them) and other such issues."))}i.isMDXComponent=!0;var s=n(9960),u=n(2263),m=n(4510),p=n(6010);const f={heroBanner:"heroBanner_e1Bh",buttons:"buttons_VwD3",features:"features_WS6B",featureSvg:"featureSvg_tqLR",titleOnBannerImage:"titleOnBannerImage_r7kd",taglineOnBannerImage:"taglineOnBannerImage_dLPr"},d=null;function b(e){let{image:t,title:n,description:r}=e;return a.createElement("div",{className:(0,p.Z)("col col--4")},t&&a.createElement("div",{className:"text--center"},a.createElement("img",{className:f.featureSvg,alt:n,src:t})),a.createElement("div",{className:"text--center padding-horiz--md"},a.createElement("h3",null,n),a.createElement("p",null,r)))}function g(){return d?a.createElement("section",{className:f.features},a.createElement("div",{className:"container"},a.createElement("div",{className:"row"},d.map(((e,t)=>a.createElement(b,(0,r.Z)({key:t},e))))))):null}function h(){const{siteConfig:e}=(0,u.Z)(),t=e.customFields.bannerImage,n=!!t,r=n?{backgroundImage:`url("${t}")`}:null,o=(0,p.Z)("hero__title",{[f.titleOnBannerImage]:n}),l=(0,p.Z)("hero__subtitle",{[f.taglineOnBannerImage]:n});return a.createElement("header",{className:(0,p.Z)("hero",f.heroBanner),style:r},a.createElement("div",{className:"container"},a.createElement("h1",{className:o},e.title),a.createElement("p",{className:l},e.tagline),a.createElement("div",{className:f.buttons},a.createElement(s.Z,{className:"button button--secondary button--lg",to:"/docs/intro"},"Get Started \u2192"))))}function y(){const{siteConfig:e,tagline:t}=(0,u.Z)();return a.createElement(m.Z,{title:e.title,description:t},a.createElement(h,null),a.createElement("main",null,a.createElement(g,null),a.createElement("div",{className:"container"},a.createElement(i,null))))}}}]);