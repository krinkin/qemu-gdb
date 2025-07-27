.section .data
msg: .ascii "hello"

.section .text
.global _start

_start:
   
    li t0, 0x10000000      # UART 
    la t1, msg            
    li t2, 5             

print_loop:
    lb t3, 0(t1)           
    sb t3, 0(t0)          
    addi t1, t1, 1         
    addi t2, t2, -1       
    bnez t2, print_loop   
    
    li t3, 10              # '\n'
    sb t3, 0(t0)
    
1:  j 1b
