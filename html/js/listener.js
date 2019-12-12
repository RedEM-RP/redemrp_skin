$(function(){
    window.onload = (e) => {
        window.addEventListener('message', (event) => {
                if (event.data.show == 1){
                    openCreator(event.data.show);
                    console.log(event.data.show);
            }
        });
    };
});