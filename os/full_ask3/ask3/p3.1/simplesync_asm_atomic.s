	.file	"simplesync.c"
	.text
.Ltext0:
	.comm	mtx,40,32
	.section	.rodata
	.align 8
.LC0:
	.string	"About to increase variable %d times\n"
.LC1:
	.string	"Done increasing variable.\n"
	.text
	.globl	increase_fn
	.type	increase_fn, @function
increase_fn:
.LFB5:
	.file 1 "simplesync.c"
	.loc 1 38 0
	.cfi_startproc
	pushq	%rbp
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	movq	%rsp, %rbp
	.cfi_def_cfa_register 6
	subq	$32, %rsp
	movq	%rdi, -24(%rbp)
	.loc 1 40 0
	movq	-24(%rbp), %rax
	movq	%rax, -8(%rbp)
	.loc 1 42 0
	movq	stderr(%rip), %rax
	movl	$10000000, %edx
	leaq	.LC0(%rip), %rsi
	movq	%rax, %rdi
	movl	$0, %eax
	call	fprintf@PLT
	.loc 1 43 0
	movl	$0, -12(%rbp)
	jmp	.L2
.L3:
	.loc 1 46 0
	movq	-8(%rbp), %rax
	lock addl	$1, (%rax)
	.loc 1 43 0
	addl	$1, -12(%rbp)
.L2:
	.loc 1 43 0 is_stmt 0 discriminator 1
	cmpl	$9999999, -12(%rbp)
	jle	.L3
	.loc 1 62 0 is_stmt 1
	movq	stderr(%rip), %rax
	movq	%rax, %rcx
	movl	$26, %edx
	movl	$1, %esi
	leaq	.LC1(%rip), %rdi
	call	fwrite@PLT
	.loc 1 64 0
	movl	$0, %eax
	.loc 1 65 0
	leave
	.cfi_def_cfa 7, 8
	ret
	.cfi_endproc
.LFE5:
	.size	increase_fn, .-increase_fn
	.section	.rodata
	.align 8
.LC2:
	.string	"About to decrease variable %d times\n"
.LC3:
	.string	"Done decreasing variable.\n"
	.text
	.globl	decrease_fn
	.type	decrease_fn, @function
decrease_fn:
.LFB6:
	.loc 1 69 0
	.cfi_startproc
	pushq	%rbp
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	movq	%rsp, %rbp
	.cfi_def_cfa_register 6
	subq	$32, %rsp
	movq	%rdi, -24(%rbp)
	.loc 1 71 0
	movq	-24(%rbp), %rax
	movq	%rax, -8(%rbp)
	.loc 1 73 0
	movq	stderr(%rip), %rax
	movl	$10000000, %edx
	leaq	.LC2(%rip), %rsi
	movq	%rax, %rdi
	movl	$0, %eax
	call	fprintf@PLT
	.loc 1 74 0
	movl	$0, -12(%rbp)
	jmp	.L6
.L7:
	.loc 1 77 0
	movq	-8(%rbp), %rax
	lock subl	$1, (%rax)
	.loc 1 74 0
	addl	$1, -12(%rbp)
.L6:
	.loc 1 74 0 is_stmt 0 discriminator 1
	cmpl	$9999999, -12(%rbp)
	jle	.L7
	.loc 1 87 0 is_stmt 1
	movq	stderr(%rip), %rax
	movq	%rax, %rcx
	movl	$26, %edx
	movl	$1, %esi
	leaq	.LC3(%rip), %rdi
	call	fwrite@PLT
	.loc 1 89 0
	movl	$0, %eax
	.loc 1 90 0
	leave
	.cfi_def_cfa 7, 8
	ret
	.cfi_endproc
.LFE6:
	.size	decrease_fn, .-decrease_fn
	.section	.rodata
.LC4:
	.string	"pthread_create"
.LC5:
	.string	"perror_join"
.LC6:
	.string	""
.LC7:
	.string	"NOT "
.LC8:
	.string	"%sOK, val = %d.\n"
	.text
	.globl	main
	.type	main, @function
main:
.LFB7:
	.loc 1 93 0
	.cfi_startproc
	pushq	%rbp
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	movq	%rsp, %rbp
	.cfi_def_cfa_register 6
	subq	$64, %rsp
	movl	%edi, -52(%rbp)
	movq	%rsi, -64(%rbp)
	.loc 1 93 0
	movq	%fs:40, %rax
	movq	%rax, -8(%rbp)
	xorl	%eax, %eax
	.loc 1 96 0
	movl	$0, %esi
	leaq	mtx(%rip), %rdi
	call	pthread_mutex_init@PLT
	.loc 1 99 0
	movl	$0, -36(%rbp)
	.loc 1 102 0
	leaq	-36(%rbp), %rdx
	leaq	-24(%rbp), %rax
	movq	%rdx, %rcx
	leaq	increase_fn(%rip), %rdx
	movl	$0, %esi
	movq	%rax, %rdi
	call	pthread_create@PLT
	movl	%eax, -32(%rbp)
	.loc 1 103 0
	cmpl	$0, -32(%rbp)
	je	.L10
	.loc 1 104 0
	call	__errno_location@PLT
	movq	%rax, %rdx
	movl	-32(%rbp), %eax
	movl	%eax, (%rdx)
	leaq	.LC4(%rip), %rdi
	call	perror@PLT
	.loc 1 105 0
	movl	$1, %edi
	call	exit@PLT
.L10:
	.loc 1 109 0
	leaq	-36(%rbp), %rdx
	leaq	-16(%rbp), %rax
	movq	%rdx, %rcx
	leaq	decrease_fn(%rip), %rdx
	movl	$0, %esi
	movq	%rax, %rdi
	call	pthread_create@PLT
	movl	%eax, -32(%rbp)
	.loc 1 110 0
	cmpl	$0, -32(%rbp)
	je	.L11
	.loc 1 111 0
	call	__errno_location@PLT
	movq	%rax, %rdx
	movl	-32(%rbp), %eax
	movl	%eax, (%rdx)
	leaq	.LC4(%rip), %rdi
	call	perror@PLT
	.loc 1 112 0
	movl	$1, %edi
	call	exit@PLT
.L11:
	.loc 1 116 0
	movq	-24(%rbp), %rax
	movl	$0, %esi
	movq	%rax, %rdi
	call	pthread_join@PLT
	movl	%eax, -32(%rbp)
	.loc 1 117 0
	cmpl	$0, -32(%rbp)
	je	.L12
	.loc 1 118 0
	call	__errno_location@PLT
	movq	%rax, %rdx
	movl	-32(%rbp), %eax
	movl	%eax, (%rdx)
	leaq	.LC5(%rip), %rdi
	call	perror@PLT
.L12:
	.loc 1 122 0
	movq	-16(%rbp), %rax
	movl	$0, %esi
	movq	%rax, %rdi
	call	pthread_join@PLT
	movl	%eax, -32(%rbp)
	.loc 1 123 0
	cmpl	$0, -32(%rbp)
	je	.L13
	.loc 1 124 0
	call	__errno_location@PLT
	movq	%rax, %rdx
	movl	-32(%rbp), %eax
	movl	%eax, (%rdx)
	leaq	.LC5(%rip), %rdi
	call	perror@PLT
.L13:
	.loc 1 128 0
	movl	-36(%rbp), %eax
	testl	%eax, %eax
	sete	%al
	movzbl	%al, %eax
	movl	%eax, -28(%rbp)
	.loc 1 129 0
	movl	-36(%rbp), %edx
	cmpl	$0, -28(%rbp)
	je	.L14
	.loc 1 129 0 is_stmt 0 discriminator 1
	leaq	.LC6(%rip), %rax
	jmp	.L15
.L14:
	.loc 1 129 0 discriminator 2
	leaq	.LC7(%rip), %rax
.L15:
	.loc 1 129 0 discriminator 4
	movq	%rax, %rsi
	leaq	.LC8(%rip), %rdi
	movl	$0, %eax
	call	printf@PLT
	.loc 1 139 0 is_stmt 1 discriminator 4
	movl	-28(%rbp), %eax
	.loc 1 140 0 discriminator 4
	movq	-8(%rbp), %rcx
	xorq	%fs:40, %rcx
	je	.L17
	.loc 1 140 0 is_stmt 0
	call	__stack_chk_fail@PLT
.L17:
	leave
	.cfi_def_cfa 7, 8
	ret
	.cfi_endproc
.LFE7:
	.size	main, .-main
.Letext0:
	.file 2 "/usr/lib/gcc/x86_64-linux-gnu/7/include/stddef.h"
	.file 3 "/usr/include/x86_64-linux-gnu/bits/types.h"
	.file 4 "/usr/include/x86_64-linux-gnu/bits/libio.h"
	.file 5 "/usr/include/stdio.h"
	.file 6 "/usr/include/x86_64-linux-gnu/bits/sys_errlist.h"
	.file 7 "/usr/include/x86_64-linux-gnu/bits/thread-shared-types.h"
	.file 8 "/usr/include/x86_64-linux-gnu/bits/pthreadtypes.h"
	.file 9 "/usr/include/unistd.h"
	.file 10 "/usr/include/x86_64-linux-gnu/bits/getopt_core.h"
	.file 11 "/usr/include/time.h"
	.section	.debug_info,"",@progbits
.Ldebug_info0:
	.long	0x5c9
	.value	0x4
	.long	.Ldebug_abbrev0
	.byte	0x8
	.uleb128 0x1
	.long	.LASF88
	.byte	0xc
	.long	.LASF89
	.long	.LASF90
	.quad	.Ltext0
	.quad	.Letext0-.Ltext0
	.long	.Ldebug_line0
	.uleb128 0x2
	.long	.LASF7
	.byte	0x2
	.byte	0xd8
	.long	0x38
	.uleb128 0x3
	.byte	0x8
	.byte	0x7
	.long	.LASF0
	.uleb128 0x3
	.byte	0x1
	.byte	0x8
	.long	.LASF1
	.uleb128 0x3
	.byte	0x2
	.byte	0x7
	.long	.LASF2
	.uleb128 0x3
	.byte	0x4
	.byte	0x7
	.long	.LASF3
	.uleb128 0x3
	.byte	0x1
	.byte	0x6
	.long	.LASF4
	.uleb128 0x3
	.byte	0x2
	.byte	0x5
	.long	.LASF5
	.uleb128 0x4
	.byte	0x4
	.byte	0x5
	.string	"int"
	.uleb128 0x5
	.long	0x62
	.uleb128 0x3
	.byte	0x8
	.byte	0x5
	.long	.LASF6
	.uleb128 0x2
	.long	.LASF8
	.byte	0x3
	.byte	0x8c
	.long	0x6e
	.uleb128 0x2
	.long	.LASF9
	.byte	0x3
	.byte	0x8d
	.long	0x6e
	.uleb128 0x6
	.byte	0x8
	.uleb128 0x7
	.byte	0x8
	.long	0x93
	.uleb128 0x3
	.byte	0x1
	.byte	0x6
	.long	.LASF10
	.uleb128 0x8
	.long	0x93
	.uleb128 0x9
	.long	.LASF40
	.byte	0xd8
	.byte	0x4
	.byte	0xf5
	.long	0x21f
	.uleb128 0xa
	.long	.LASF11
	.byte	0x4
	.byte	0xf6
	.long	0x62
	.byte	0
	.uleb128 0xa
	.long	.LASF12
	.byte	0x4
	.byte	0xfb
	.long	0x8d
	.byte	0x8
	.uleb128 0xa
	.long	.LASF13
	.byte	0x4
	.byte	0xfc
	.long	0x8d
	.byte	0x10
	.uleb128 0xa
	.long	.LASF14
	.byte	0x4
	.byte	0xfd
	.long	0x8d
	.byte	0x18
	.uleb128 0xa
	.long	.LASF15
	.byte	0x4
	.byte	0xfe
	.long	0x8d
	.byte	0x20
	.uleb128 0xa
	.long	.LASF16
	.byte	0x4
	.byte	0xff
	.long	0x8d
	.byte	0x28
	.uleb128 0xb
	.long	.LASF17
	.byte	0x4
	.value	0x100
	.long	0x8d
	.byte	0x30
	.uleb128 0xb
	.long	.LASF18
	.byte	0x4
	.value	0x101
	.long	0x8d
	.byte	0x38
	.uleb128 0xb
	.long	.LASF19
	.byte	0x4
	.value	0x102
	.long	0x8d
	.byte	0x40
	.uleb128 0xb
	.long	.LASF20
	.byte	0x4
	.value	0x104
	.long	0x8d
	.byte	0x48
	.uleb128 0xb
	.long	.LASF21
	.byte	0x4
	.value	0x105
	.long	0x8d
	.byte	0x50
	.uleb128 0xb
	.long	.LASF22
	.byte	0x4
	.value	0x106
	.long	0x8d
	.byte	0x58
	.uleb128 0xb
	.long	.LASF23
	.byte	0x4
	.value	0x108
	.long	0x257
	.byte	0x60
	.uleb128 0xb
	.long	.LASF24
	.byte	0x4
	.value	0x10a
	.long	0x25d
	.byte	0x68
	.uleb128 0xb
	.long	.LASF25
	.byte	0x4
	.value	0x10c
	.long	0x62
	.byte	0x70
	.uleb128 0xb
	.long	.LASF26
	.byte	0x4
	.value	0x110
	.long	0x62
	.byte	0x74
	.uleb128 0xb
	.long	.LASF27
	.byte	0x4
	.value	0x112
	.long	0x75
	.byte	0x78
	.uleb128 0xb
	.long	.LASF28
	.byte	0x4
	.value	0x116
	.long	0x46
	.byte	0x80
	.uleb128 0xb
	.long	.LASF29
	.byte	0x4
	.value	0x117
	.long	0x54
	.byte	0x82
	.uleb128 0xb
	.long	.LASF30
	.byte	0x4
	.value	0x118
	.long	0x263
	.byte	0x83
	.uleb128 0xb
	.long	.LASF31
	.byte	0x4
	.value	0x11c
	.long	0x273
	.byte	0x88
	.uleb128 0xb
	.long	.LASF32
	.byte	0x4
	.value	0x125
	.long	0x80
	.byte	0x90
	.uleb128 0xb
	.long	.LASF33
	.byte	0x4
	.value	0x12d
	.long	0x8b
	.byte	0x98
	.uleb128 0xb
	.long	.LASF34
	.byte	0x4
	.value	0x12e
	.long	0x8b
	.byte	0xa0
	.uleb128 0xb
	.long	.LASF35
	.byte	0x4
	.value	0x12f
	.long	0x8b
	.byte	0xa8
	.uleb128 0xb
	.long	.LASF36
	.byte	0x4
	.value	0x130
	.long	0x8b
	.byte	0xb0
	.uleb128 0xb
	.long	.LASF37
	.byte	0x4
	.value	0x132
	.long	0x2d
	.byte	0xb8
	.uleb128 0xb
	.long	.LASF38
	.byte	0x4
	.value	0x133
	.long	0x62
	.byte	0xc0
	.uleb128 0xb
	.long	.LASF39
	.byte	0x4
	.value	0x135
	.long	0x279
	.byte	0xc4
	.byte	0
	.uleb128 0xc
	.long	.LASF91
	.byte	0x4
	.byte	0x9a
	.uleb128 0x9
	.long	.LASF41
	.byte	0x18
	.byte	0x4
	.byte	0xa0
	.long	0x257
	.uleb128 0xa
	.long	.LASF42
	.byte	0x4
	.byte	0xa1
	.long	0x257
	.byte	0
	.uleb128 0xa
	.long	.LASF43
	.byte	0x4
	.byte	0xa2
	.long	0x25d
	.byte	0x8
	.uleb128 0xa
	.long	.LASF44
	.byte	0x4
	.byte	0xa6
	.long	0x62
	.byte	0x10
	.byte	0
	.uleb128 0x7
	.byte	0x8
	.long	0x226
	.uleb128 0x7
	.byte	0x8
	.long	0x9f
	.uleb128 0xd
	.long	0x93
	.long	0x273
	.uleb128 0xe
	.long	0x38
	.byte	0
	.byte	0
	.uleb128 0x7
	.byte	0x8
	.long	0x21f
	.uleb128 0xd
	.long	0x93
	.long	0x289
	.uleb128 0xe
	.long	0x38
	.byte	0x13
	.byte	0
	.uleb128 0xf
	.long	.LASF92
	.uleb128 0x10
	.long	.LASF45
	.byte	0x4
	.value	0x13f
	.long	0x289
	.uleb128 0x10
	.long	.LASF46
	.byte	0x4
	.value	0x140
	.long	0x289
	.uleb128 0x10
	.long	.LASF47
	.byte	0x4
	.value	0x141
	.long	0x289
	.uleb128 0x7
	.byte	0x8
	.long	0x9a
	.uleb128 0x8
	.long	0x2b2
	.uleb128 0x11
	.long	.LASF48
	.byte	0x5
	.byte	0x87
	.long	0x25d
	.uleb128 0x11
	.long	.LASF49
	.byte	0x5
	.byte	0x88
	.long	0x25d
	.uleb128 0x11
	.long	.LASF50
	.byte	0x5
	.byte	0x89
	.long	0x25d
	.uleb128 0x11
	.long	.LASF51
	.byte	0x6
	.byte	0x1a
	.long	0x62
	.uleb128 0xd
	.long	0x2b8
	.long	0x2f4
	.uleb128 0x12
	.byte	0
	.uleb128 0x8
	.long	0x2e9
	.uleb128 0x11
	.long	.LASF52
	.byte	0x6
	.byte	0x1b
	.long	0x2f4
	.uleb128 0x3
	.byte	0x8
	.byte	0x5
	.long	.LASF53
	.uleb128 0x9
	.long	.LASF54
	.byte	0x10
	.byte	0x7
	.byte	0x52
	.long	0x330
	.uleb128 0xa
	.long	.LASF55
	.byte	0x7
	.byte	0x54
	.long	0x330
	.byte	0
	.uleb128 0xa
	.long	.LASF56
	.byte	0x7
	.byte	0x55
	.long	0x330
	.byte	0x8
	.byte	0
	.uleb128 0x7
	.byte	0x8
	.long	0x30b
	.uleb128 0x2
	.long	.LASF57
	.byte	0x7
	.byte	0x56
	.long	0x30b
	.uleb128 0x9
	.long	.LASF58
	.byte	0x28
	.byte	0x7
	.byte	0x76
	.long	0x3ae
	.uleb128 0xa
	.long	.LASF59
	.byte	0x7
	.byte	0x78
	.long	0x62
	.byte	0
	.uleb128 0xa
	.long	.LASF60
	.byte	0x7
	.byte	0x79
	.long	0x4d
	.byte	0x4
	.uleb128 0xa
	.long	.LASF61
	.byte	0x7
	.byte	0x7a
	.long	0x62
	.byte	0x8
	.uleb128 0xa
	.long	.LASF62
	.byte	0x7
	.byte	0x7c
	.long	0x4d
	.byte	0xc
	.uleb128 0xa
	.long	.LASF63
	.byte	0x7
	.byte	0x80
	.long	0x62
	.byte	0x10
	.uleb128 0xa
	.long	.LASF64
	.byte	0x7
	.byte	0x86
	.long	0x5b
	.byte	0x14
	.uleb128 0xa
	.long	.LASF65
	.byte	0x7
	.byte	0x86
	.long	0x5b
	.byte	0x16
	.uleb128 0xa
	.long	.LASF66
	.byte	0x7
	.byte	0x87
	.long	0x336
	.byte	0x18
	.byte	0
	.uleb128 0x3
	.byte	0x8
	.byte	0x7
	.long	.LASF67
	.uleb128 0x2
	.long	.LASF68
	.byte	0x8
	.byte	0x1b
	.long	0x38
	.uleb128 0x13
	.byte	0x28
	.byte	0x8
	.byte	0x43
	.long	0x3ea
	.uleb128 0x14
	.long	.LASF69
	.byte	0x8
	.byte	0x45
	.long	0x341
	.uleb128 0x14
	.long	.LASF70
	.byte	0x8
	.byte	0x46
	.long	0x3ea
	.uleb128 0x14
	.long	.LASF71
	.byte	0x8
	.byte	0x47
	.long	0x6e
	.byte	0
	.uleb128 0xd
	.long	0x93
	.long	0x3fa
	.uleb128 0xe
	.long	0x38
	.byte	0x27
	.byte	0
	.uleb128 0x2
	.long	.LASF72
	.byte	0x8
	.byte	0x48
	.long	0x3c0
	.uleb128 0x10
	.long	.LASF73
	.byte	0x9
	.value	0x222
	.long	0x411
	.uleb128 0x7
	.byte	0x8
	.long	0x8d
	.uleb128 0x11
	.long	.LASF74
	.byte	0xa
	.byte	0x24
	.long	0x8d
	.uleb128 0x11
	.long	.LASF75
	.byte	0xa
	.byte	0x32
	.long	0x62
	.uleb128 0x11
	.long	.LASF76
	.byte	0xa
	.byte	0x37
	.long	0x62
	.uleb128 0x11
	.long	.LASF77
	.byte	0xa
	.byte	0x3b
	.long	0x62
	.uleb128 0xd
	.long	0x8d
	.long	0x453
	.uleb128 0xe
	.long	0x38
	.byte	0x1
	.byte	0
	.uleb128 0x11
	.long	.LASF78
	.byte	0xb
	.byte	0x9f
	.long	0x443
	.uleb128 0x11
	.long	.LASF79
	.byte	0xb
	.byte	0xa0
	.long	0x62
	.uleb128 0x11
	.long	.LASF80
	.byte	0xb
	.byte	0xa1
	.long	0x6e
	.uleb128 0x11
	.long	.LASF81
	.byte	0xb
	.byte	0xa6
	.long	0x443
	.uleb128 0x11
	.long	.LASF82
	.byte	0xb
	.byte	0xae
	.long	0x62
	.uleb128 0x11
	.long	.LASF83
	.byte	0xb
	.byte	0xaf
	.long	0x6e
	.uleb128 0x15
	.string	"mtx"
	.byte	0x1
	.byte	0x22
	.long	0x3fa
	.uleb128 0x9
	.byte	0x3
	.quad	mtx
	.uleb128 0x16
	.long	.LASF86
	.byte	0x1
	.byte	0x5c
	.long	0x62
	.quad	.LFB7
	.quad	.LFE7-.LFB7
	.uleb128 0x1
	.byte	0x9c
	.long	0x52d
	.uleb128 0x17
	.long	.LASF84
	.byte	0x1
	.byte	0x5c
	.long	0x62
	.uleb128 0x3
	.byte	0x91
	.sleb128 -68
	.uleb128 0x17
	.long	.LASF85
	.byte	0x1
	.byte	0x5c
	.long	0x411
	.uleb128 0x3
	.byte	0x91
	.sleb128 -80
	.uleb128 0x18
	.string	"val"
	.byte	0x1
	.byte	0x5e
	.long	0x62
	.uleb128 0x2
	.byte	0x91
	.sleb128 -52
	.uleb128 0x18
	.string	"ret"
	.byte	0x1
	.byte	0x5e
	.long	0x62
	.uleb128 0x2
	.byte	0x91
	.sleb128 -48
	.uleb128 0x18
	.string	"ok"
	.byte	0x1
	.byte	0x5e
	.long	0x62
	.uleb128 0x2
	.byte	0x91
	.sleb128 -44
	.uleb128 0x18
	.string	"t1"
	.byte	0x1
	.byte	0x5f
	.long	0x3b5
	.uleb128 0x2
	.byte	0x91
	.sleb128 -40
	.uleb128 0x18
	.string	"t2"
	.byte	0x1
	.byte	0x5f
	.long	0x3b5
	.uleb128 0x2
	.byte	0x91
	.sleb128 -32
	.byte	0
	.uleb128 0x16
	.long	.LASF87
	.byte	0x1
	.byte	0x44
	.long	0x8b
	.quad	.LFB6
	.quad	.LFE6-.LFB6
	.uleb128 0x1
	.byte	0x9c
	.long	0x576
	.uleb128 0x19
	.string	"arg"
	.byte	0x1
	.byte	0x44
	.long	0x8b
	.uleb128 0x2
	.byte	0x91
	.sleb128 -40
	.uleb128 0x18
	.string	"i"
	.byte	0x1
	.byte	0x46
	.long	0x62
	.uleb128 0x2
	.byte	0x91
	.sleb128 -28
	.uleb128 0x18
	.string	"ip"
	.byte	0x1
	.byte	0x47
	.long	0x576
	.uleb128 0x2
	.byte	0x91
	.sleb128 -24
	.byte	0
	.uleb128 0x7
	.byte	0x8
	.long	0x69
	.uleb128 0x1a
	.long	.LASF93
	.byte	0x1
	.byte	0x25
	.long	0x8b
	.quad	.LFB5
	.quad	.LFE5-.LFB5
	.uleb128 0x1
	.byte	0x9c
	.uleb128 0x19
	.string	"arg"
	.byte	0x1
	.byte	0x25
	.long	0x8b
	.uleb128 0x2
	.byte	0x91
	.sleb128 -40
	.uleb128 0x18
	.string	"i"
	.byte	0x1
	.byte	0x27
	.long	0x62
	.uleb128 0x2
	.byte	0x91
	.sleb128 -28
	.uleb128 0x1b
	.string	"ret"
	.byte	0x1
	.byte	0x27
	.long	0x62
	.uleb128 0x18
	.string	"ip"
	.byte	0x1
	.byte	0x28
	.long	0x576
	.uleb128 0x2
	.byte	0x91
	.sleb128 -24
	.byte	0
	.byte	0
	.section	.debug_abbrev,"",@progbits
.Ldebug_abbrev0:
	.uleb128 0x1
	.uleb128 0x11
	.byte	0x1
	.uleb128 0x25
	.uleb128 0xe
	.uleb128 0x13
	.uleb128 0xb
	.uleb128 0x3
	.uleb128 0xe
	.uleb128 0x1b
	.uleb128 0xe
	.uleb128 0x11
	.uleb128 0x1
	.uleb128 0x12
	.uleb128 0x7
	.uleb128 0x10
	.uleb128 0x17
	.byte	0
	.byte	0
	.uleb128 0x2
	.uleb128 0x16
	.byte	0
	.uleb128 0x3
	.uleb128 0xe
	.uleb128 0x3a
	.uleb128 0xb
	.uleb128 0x3b
	.uleb128 0xb
	.uleb128 0x49
	.uleb128 0x13
	.byte	0
	.byte	0
	.uleb128 0x3
	.uleb128 0x24
	.byte	0
	.uleb128 0xb
	.uleb128 0xb
	.uleb128 0x3e
	.uleb128 0xb
	.uleb128 0x3
	.uleb128 0xe
	.byte	0
	.byte	0
	.uleb128 0x4
	.uleb128 0x24
	.byte	0
	.uleb128 0xb
	.uleb128 0xb
	.uleb128 0x3e
	.uleb128 0xb
	.uleb128 0x3
	.uleb128 0x8
	.byte	0
	.byte	0
	.uleb128 0x5
	.uleb128 0x35
	.byte	0
	.uleb128 0x49
	.uleb128 0x13
	.byte	0
	.byte	0
	.uleb128 0x6
	.uleb128 0xf
	.byte	0
	.uleb128 0xb
	.uleb128 0xb
	.byte	0
	.byte	0
	.uleb128 0x7
	.uleb128 0xf
	.byte	0
	.uleb128 0xb
	.uleb128 0xb
	.uleb128 0x49
	.uleb128 0x13
	.byte	0
	.byte	0
	.uleb128 0x8
	.uleb128 0x26
	.byte	0
	.uleb128 0x49
	.uleb128 0x13
	.byte	0
	.byte	0
	.uleb128 0x9
	.uleb128 0x13
	.byte	0x1
	.uleb128 0x3
	.uleb128 0xe
	.uleb128 0xb
	.uleb128 0xb
	.uleb128 0x3a
	.uleb128 0xb
	.uleb128 0x3b
	.uleb128 0xb
	.uleb128 0x1
	.uleb128 0x13
	.byte	0
	.byte	0
	.uleb128 0xa
	.uleb128 0xd
	.byte	0
	.uleb128 0x3
	.uleb128 0xe
	.uleb128 0x3a
	.uleb128 0xb
	.uleb128 0x3b
	.uleb128 0xb
	.uleb128 0x49
	.uleb128 0x13
	.uleb128 0x38
	.uleb128 0xb
	.byte	0
	.byte	0
	.uleb128 0xb
	.uleb128 0xd
	.byte	0
	.uleb128 0x3
	.uleb128 0xe
	.uleb128 0x3a
	.uleb128 0xb
	.uleb128 0x3b
	.uleb128 0x5
	.uleb128 0x49
	.uleb128 0x13
	.uleb128 0x38
	.uleb128 0xb
	.byte	0
	.byte	0
	.uleb128 0xc
	.uleb128 0x16
	.byte	0
	.uleb128 0x3
	.uleb128 0xe
	.uleb128 0x3a
	.uleb128 0xb
	.uleb128 0x3b
	.uleb128 0xb
	.byte	0
	.byte	0
	.uleb128 0xd
	.uleb128 0x1
	.byte	0x1
	.uleb128 0x49
	.uleb128 0x13
	.uleb128 0x1
	.uleb128 0x13
	.byte	0
	.byte	0
	.uleb128 0xe
	.uleb128 0x21
	.byte	0
	.uleb128 0x49
	.uleb128 0x13
	.uleb128 0x2f
	.uleb128 0xb
	.byte	0
	.byte	0
	.uleb128 0xf
	.uleb128 0x13
	.byte	0
	.uleb128 0x3
	.uleb128 0xe
	.uleb128 0x3c
	.uleb128 0x19
	.byte	0
	.byte	0
	.uleb128 0x10
	.uleb128 0x34
	.byte	0
	.uleb128 0x3
	.uleb128 0xe
	.uleb128 0x3a
	.uleb128 0xb
	.uleb128 0x3b
	.uleb128 0x5
	.uleb128 0x49
	.uleb128 0x13
	.uleb128 0x3f
	.uleb128 0x19
	.uleb128 0x3c
	.uleb128 0x19
	.byte	0
	.byte	0
	.uleb128 0x11
	.uleb128 0x34
	.byte	0
	.uleb128 0x3
	.uleb128 0xe
	.uleb128 0x3a
	.uleb128 0xb
	.uleb128 0x3b
	.uleb128 0xb
	.uleb128 0x49
	.uleb128 0x13
	.uleb128 0x3f
	.uleb128 0x19
	.uleb128 0x3c
	.uleb128 0x19
	.byte	0
	.byte	0
	.uleb128 0x12
	.uleb128 0x21
	.byte	0
	.byte	0
	.byte	0
	.uleb128 0x13
	.uleb128 0x17
	.byte	0x1
	.uleb128 0xb
	.uleb128 0xb
	.uleb128 0x3a
	.uleb128 0xb
	.uleb128 0x3b
	.uleb128 0xb
	.uleb128 0x1
	.uleb128 0x13
	.byte	0
	.byte	0
	.uleb128 0x14
	.uleb128 0xd
	.byte	0
	.uleb128 0x3
	.uleb128 0xe
	.uleb128 0x3a
	.uleb128 0xb
	.uleb128 0x3b
	.uleb128 0xb
	.uleb128 0x49
	.uleb128 0x13
	.byte	0
	.byte	0
	.uleb128 0x15
	.uleb128 0x34
	.byte	0
	.uleb128 0x3
	.uleb128 0x8
	.uleb128 0x3a
	.uleb128 0xb
	.uleb128 0x3b
	.uleb128 0xb
	.uleb128 0x49
	.uleb128 0x13
	.uleb128 0x3f
	.uleb128 0x19
	.uleb128 0x2
	.uleb128 0x18
	.byte	0
	.byte	0
	.uleb128 0x16
	.uleb128 0x2e
	.byte	0x1
	.uleb128 0x3f
	.uleb128 0x19
	.uleb128 0x3
	.uleb128 0xe
	.uleb128 0x3a
	.uleb128 0xb
	.uleb128 0x3b
	.uleb128 0xb
	.uleb128 0x27
	.uleb128 0x19
	.uleb128 0x49
	.uleb128 0x13
	.uleb128 0x11
	.uleb128 0x1
	.uleb128 0x12
	.uleb128 0x7
	.uleb128 0x40
	.uleb128 0x18
	.uleb128 0x2116
	.uleb128 0x19
	.uleb128 0x1
	.uleb128 0x13
	.byte	0
	.byte	0
	.uleb128 0x17
	.uleb128 0x5
	.byte	0
	.uleb128 0x3
	.uleb128 0xe
	.uleb128 0x3a
	.uleb128 0xb
	.uleb128 0x3b
	.uleb128 0xb
	.uleb128 0x49
	.uleb128 0x13
	.uleb128 0x2
	.uleb128 0x18
	.byte	0
	.byte	0
	.uleb128 0x18
	.uleb128 0x34
	.byte	0
	.uleb128 0x3
	.uleb128 0x8
	.uleb128 0x3a
	.uleb128 0xb
	.uleb128 0x3b
	.uleb128 0xb
	.uleb128 0x49
	.uleb128 0x13
	.uleb128 0x2
	.uleb128 0x18
	.byte	0
	.byte	0
	.uleb128 0x19
	.uleb128 0x5
	.byte	0
	.uleb128 0x3
	.uleb128 0x8
	.uleb128 0x3a
	.uleb128 0xb
	.uleb128 0x3b
	.uleb128 0xb
	.uleb128 0x49
	.uleb128 0x13
	.uleb128 0x2
	.uleb128 0x18
	.byte	0
	.byte	0
	.uleb128 0x1a
	.uleb128 0x2e
	.byte	0x1
	.uleb128 0x3f
	.uleb128 0x19
	.uleb128 0x3
	.uleb128 0xe
	.uleb128 0x3a
	.uleb128 0xb
	.uleb128 0x3b
	.uleb128 0xb
	.uleb128 0x27
	.uleb128 0x19
	.uleb128 0x49
	.uleb128 0x13
	.uleb128 0x11
	.uleb128 0x1
	.uleb128 0x12
	.uleb128 0x7
	.uleb128 0x40
	.uleb128 0x18
	.uleb128 0x2116
	.uleb128 0x19
	.byte	0
	.byte	0
	.uleb128 0x1b
	.uleb128 0x34
	.byte	0
	.uleb128 0x3
	.uleb128 0x8
	.uleb128 0x3a
	.uleb128 0xb
	.uleb128 0x3b
	.uleb128 0xb
	.uleb128 0x49
	.uleb128 0x13
	.byte	0
	.byte	0
	.byte	0
	.section	.debug_aranges,"",@progbits
	.long	0x2c
	.value	0x2
	.long	.Ldebug_info0
	.byte	0x8
	.byte	0
	.value	0
	.value	0
	.quad	.Ltext0
	.quad	.Letext0-.Ltext0
	.quad	0
	.quad	0
	.section	.debug_line,"",@progbits
.Ldebug_line0:
	.section	.debug_str,"MS",@progbits,1
.LASF75:
	.string	"optind"
.LASF74:
	.string	"optarg"
.LASF69:
	.string	"__data"
.LASF40:
	.string	"_IO_FILE"
.LASF51:
	.string	"sys_nerr"
.LASF22:
	.string	"_IO_save_end"
.LASF5:
	.string	"short int"
.LASF7:
	.string	"size_t"
.LASF32:
	.string	"_offset"
.LASF54:
	.string	"__pthread_internal_list"
.LASF16:
	.string	"_IO_write_ptr"
.LASF11:
	.string	"_flags"
.LASF72:
	.string	"pthread_mutex_t"
.LASF90:
	.string	"/home/george/Desktop/code/os/ask3/p3.1"
.LASF60:
	.string	"__count"
.LASF73:
	.string	"__environ"
.LASF23:
	.string	"_markers"
.LASF13:
	.string	"_IO_read_end"
.LASF83:
	.string	"timezone"
.LASF82:
	.string	"daylight"
.LASF55:
	.string	"__prev"
.LASF88:
	.string	"GNU C11 7.3.0 -mtune=generic -march=x86-64 -g -fstack-protector-strong"
.LASF56:
	.string	"__next"
.LASF50:
	.string	"stderr"
.LASF63:
	.string	"__kind"
.LASF53:
	.string	"long long int"
.LASF80:
	.string	"__timezone"
.LASF31:
	.string	"_lock"
.LASF79:
	.string	"__daylight"
.LASF6:
	.string	"long int"
.LASF28:
	.string	"_cur_column"
.LASF47:
	.string	"_IO_2_1_stderr_"
.LASF92:
	.string	"_IO_FILE_plus"
.LASF44:
	.string	"_pos"
.LASF64:
	.string	"__spins"
.LASF15:
	.string	"_IO_write_base"
.LASF85:
	.string	"argv"
.LASF43:
	.string	"_sbuf"
.LASF27:
	.string	"_old_offset"
.LASF1:
	.string	"unsigned char"
.LASF84:
	.string	"argc"
.LASF4:
	.string	"signed char"
.LASF67:
	.string	"long long unsigned int"
.LASF45:
	.string	"_IO_2_1_stdin_"
.LASF3:
	.string	"unsigned int"
.LASF41:
	.string	"_IO_marker"
.LASF30:
	.string	"_shortbuf"
.LASF81:
	.string	"tzname"
.LASF39:
	.string	"_unused2"
.LASF76:
	.string	"opterr"
.LASF70:
	.string	"__size"
.LASF19:
	.string	"_IO_buf_end"
.LASF10:
	.string	"char"
.LASF62:
	.string	"__nusers"
.LASF86:
	.string	"main"
.LASF89:
	.string	"simplesync.c"
.LASF42:
	.string	"_next"
.LASF33:
	.string	"__pad1"
.LASF34:
	.string	"__pad2"
.LASF35:
	.string	"__pad3"
.LASF36:
	.string	"__pad4"
.LASF37:
	.string	"__pad5"
.LASF59:
	.string	"__lock"
.LASF61:
	.string	"__owner"
.LASF2:
	.string	"short unsigned int"
.LASF93:
	.string	"increase_fn"
.LASF58:
	.string	"__pthread_mutex_s"
.LASF0:
	.string	"long unsigned int"
.LASF17:
	.string	"_IO_write_end"
.LASF9:
	.string	"__off64_t"
.LASF65:
	.string	"__elision"
.LASF25:
	.string	"_fileno"
.LASF24:
	.string	"_chain"
.LASF57:
	.string	"__pthread_list_t"
.LASF87:
	.string	"decrease_fn"
.LASF78:
	.string	"__tzname"
.LASF8:
	.string	"__off_t"
.LASF21:
	.string	"_IO_backup_base"
.LASF48:
	.string	"stdin"
.LASF18:
	.string	"_IO_buf_base"
.LASF26:
	.string	"_flags2"
.LASF38:
	.string	"_mode"
.LASF14:
	.string	"_IO_read_base"
.LASF66:
	.string	"__list"
.LASF29:
	.string	"_vtable_offset"
.LASF20:
	.string	"_IO_save_base"
.LASF52:
	.string	"sys_errlist"
.LASF77:
	.string	"optopt"
.LASF12:
	.string	"_IO_read_ptr"
.LASF68:
	.string	"pthread_t"
.LASF71:
	.string	"__align"
.LASF49:
	.string	"stdout"
.LASF46:
	.string	"_IO_2_1_stdout_"
.LASF91:
	.string	"_IO_lock_t"
	.ident	"GCC: (Ubuntu 7.3.0-27ubuntu1~18.04) 7.3.0"
	.section	.note.GNU-stack,"",@progbits
