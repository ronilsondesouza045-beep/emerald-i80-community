const button=document.querySelector('#copy');
button?.addEventListener('click',async()=>{await navigator.clipboard.writeText('set realmlist 100.x.y.z');button.textContent='Copiado!';setTimeout(()=>button.textContent='Copiar exemplo',1600)});
