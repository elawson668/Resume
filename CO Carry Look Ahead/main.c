#include <stdio.h>

void cla(unsigned long a[], unsigned long b[], unsigned long (*sum)[]) {

    // Compute g[i] and p[i]
    unsigned long i;
    unsigned long g[64], p[64];
    for(i = 0; i < 64; i++) {
        g[i] = a[i] & b[i];
        p[i] = a[i] | b[i];
    }

    // Compute gg[j] and gp[j]
    unsigned long j;
    unsigned long gg[16], gp[16];
    for(i = 0, j = 0; j < 16; i+=4, j++) {
        gg[j] = g[i+3] | (p[i+3] & g[i+2]) | (p[i+3] & p[i+2] & g[i+1]) | (p[i+3] & p[i+2] & p[i+1] & g[i]);
        gp[j] = p[i+3] & p[i+2] & p[i+1] & p[i];
    }

    // Compute sg[k] and sp[k]
    unsigned long k;
    unsigned long sg[4], sp[4];
    for(j = 0, k = 0; k < 4; j+=4, k++) {
        sg[k] = gg[j+3] | (gp[j+3] & gg[j+2]) | (gp[j+3] & gp[j+2] & gg[j+1]) | (gp[j+3] & gp[j+2] & gp[j+1] & gg[j]);
        sp[k] = gp[j+3] & gp[j+2] & gp[j+1] & gp[j];       
    }

    // Compute sc[k] using sg[k],sp[k] and 0 for the carry in
    unsigned long sc[4];
    k = 0;
    sc[k] = sg[k] | (sp[k] & 0);
    sc[k+1] = sg[k+1] | (sp[k+1] & sc[k]);
    sc[k+2] = sg[k+2] | (sp[k+2] & sc[k+1]);
    sc[k+3] = sg[k+3] | (sp[k+3] & sc[k+2]);

    // Compute gc[j] using gg[j],gp[j], and sc[k] as the sectional carry in
    unsigned long gc[16];
    for(j = 0, k = 0; j < 16; j+= 4, k++) {
        if(j == 0) gc[j] = gg[j] | (gp[j] & 0);     // Initial carry in is 0
        else gc[j] = gg[j] | (gp[j] & sc[k]);
        gc[j+1] = gg[j+1] | (gp[j+1] & gc[j]);
        gc[j+2] = gg[j+2] | (gp[j+2] & gc[j+1]);
        gc[j+3] = gg[j+3] | (gp[j+3] & gc[j+2]);
    }

    // Compute c[i] using g[i],p[i], and gc[j] as the group carry in
    unsigned long c[64];
    for(i = 0, j = 0; i < 64; i+= 4, j++) {
        if(i == 0) c[i] = g[i] | (p[i] & 0);        // Initial carry in is 0
        else c[i] = g[i] | (p[i] & gc[j]);
        c[i+1] = g[i+1] | (p[i+1] & c[i]);
        c[i+2] = g[i+2] | (p[i+2] & c[i+1]);
        c[i+3] = g[i+3] | (p[i+3] & c[i+2]);
    }

    // Compute the sums using a[i] xor b[i] xor c[i-1]
    for(i = 0; i < 64; i++) {
        if(i == 0) (*sum)[i] = a[i] ^ b[i] ^ 0;
        else (*sum)[i] = a[i] ^ b[i] ^ c[i-1];
    }
    
}

int main() {
    unsigned long A,B;
    printf("Enter A (hex): ");
    scanf("%lx",&A);
    printf("\nEnter B (hex): ");
    scanf("%lx", &B);
    printf("\n\n");


    printf("A is %016lx or %lu\n",A,A);
    printf("B is %016lx or %lu\n",B,B);   
    printf("\n");

    printf("Calculate sum, S:\n");
    printf("\n");

    // Convert hex input to binary
    unsigned long i;
    unsigned long a[64], b[64];
    for(i = 0; i < 64; i++) {
        a[i] = A & 1;
        A = A >> 1;
    }
    for(i = 0; i < 64; i++) {
        b[i] = B & 1;
        B = B >> 1;
    }

    printf("A (bin): ");
    for(i = 64; i > 0; i--) {
        printf("%lu", a[i-1]);
    }
    printf("\n");

    printf("B (bin): ");
    for(i = 64; i > 0; i--) {
        printf("%lu", b[i-1]);
    }
    printf("\n");

    // Calculate sum
    unsigned long sum[64] = {0};
    cla(a,b,&sum);

    printf("S (bin): ");
    for(i = 64; i > 0; i--) {
        printf("%lu",sum[i-1]);
    }
    printf("\n");

    // Convert binary sum back to hex
    unsigned long S = 0; 
    for(i = 0; i < 64; i++) {
        unsigned long cur_bit = sum[i] & 1;
        S += cur_bit * (1 << i);
    }

    printf("\n");
    printf("S is %016lx or %lu\n",S,S);

  
    return 0;
}










