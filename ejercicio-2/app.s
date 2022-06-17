
.equ SCREEN_WIDTH, 		640
.equ SCREEN_HEIGH, 		480
.equ BITS_PER_PIXEL,  	32


.globl main
main:
	mov		x24, 3		//cantidad de cactus
	mov		x19, 1
	mov 	x25, 610 	//posicion del cactus x0
	mov 	x26, 200 	//posicion del dino y0
	mov		x27, 610	// posicion de la nuve
	mov		x29, 1		// tipo de cactus
mainpostinit:

	// dibujo fondo
	// X0 contiene la direccion base del framebuffer - tiene el (0,0) del framebuffer
 	mov 	x20, x0	// Tengo que hacer un arreglo que tiene el tamaño del framebuffer 
 	mov 	x20, x0	// Save framebuffer base address to x20
 	
	//add 	x20, x0, x0	  guardo el doble del framebufer	
	
	
	//---------------- CODE HERE ------------------------------------

	movz 	x10, 0x76, lsl 16
	movk 	x10, 0xadd0, lsl 00
	mov 	x1, #0
	mov 	x2, #0
	mov 	x3, SCREEN_WIDTH
	mov 	x4, SCREEN_HEIGH
	bl 		doRectangulo

	movz 	x10, 0xec, lsl 16
	movk 	x10, 0xe2c6, lsl 00
	mov 	x1, #0
	mov 	x2, #270
	mov 	x3, SCREEN_WIDTH
	mov 	x4, SCREEN_HEIGH - 270
	bl 		doGradiente
	

// cactus

	movz 	x10, 0x00, lsl 16
	movk 	x10, 0xbb2d, lsl 00
	
	cbz		x24, ultimocactus
	sub 	x25, x25, 5	//muevo el cuadrado proximamente cactus -velocity-
endultic:
	
	cmp		x25, xzr 
	b.le	resetcactus

	mov 	x1, x25
	mov 	x2, #200
	
	mov		x18, x29
	bl 		doCactusT

// clouds

    mov x1, x27
	sub x27, x27, 1
    mov x2, #100
    // x10 -> Color
	bl		doCloud


// movimiento dino

	cbz		x24, ultimodino 

	cmp		x25, 200
	b.lt	bajardino
	cmp		x25, 400
	b.lt	subirdino

endydino:
	

// dibujar dino

	add 	x19, x19, 1
	cmp 	x19, #4
	b.eq 	resetdino

doDino:
	mov 	x1, #200
	mov 	x2, x26
	bl doDinoT


//rectangulo rojo para comprobar parpadeo
	movz 	x10, 0xff, lsl 16
	movk 	x10, 0x0000, lsl 00
	mov 	x1, #0
	mov 	x2, #0
	mov 	x3, 50
	mov 	x4, 50
	bl 		doRectangulo

	//---------------------------------------------------------------
	// Infinite Loop

	mov 	x28, 1
	lsl 	x28,x28,22	//velocity
	b 		delay

	//b		main

EndLopp:
	b EndLopp











resetdino:
	mov		x19, 1
	ret

delay:
	add 	xzr,xzr,xzr
	subs 	x28, x28, 1
	cbnz 	x28, delay

	b 		mainpostinit

subirdino:
	sub		x26, x26, 2
	b		endydino

bajardino:
	cmp		x26, 200
	b.lt	bajardinoreal
	b		endydino

bajardinoreal:
	add		x26, x26, 3
	b		endydino

resetcactus:
	mov 	x25, 610
	sub 	x24, x24, 1
    add     x29, x29, 1

    cmp     x29, 4
    b.lt    cacmincua	
    mov     x29, 1
cacmincua:    
    ret

ultimocactus:
	cmp		x25, #270
	b.eq 	endultic
	sub 	x25, x25, 5
	b 		endultic

ultimodino:
	cmp 	x25, #270
	b.ne	doDino
	mov 	x19, 4
	b		doDino


