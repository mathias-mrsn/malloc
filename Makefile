NAME	:=	malloc.so

SRCS	=	commun.c \
			malloc_internal.c \
			bucket.c \
			slot.c \
			leaks_safety.c \
			free_internal.c \
			show_alloc_mem_internal.c \
			libmalloc.c \
			defragment_heap_internal.c \
			realloc_internal.c \
			print_memory.c \
			leaks_internal.c

OBJS	=	$(addprefix ${OBJDIR}/,${SRCS:.c=.o})
CC		=	clang
FLAGS	=	-pthread -g3 -fPIC
INCS	=	-I ./src
OBJDIR 	=	.objs
SRCDIR 	= 	./src

ifeq ($(HOSTTYPE),)
	HOSTTYPE := $(shell uname -m)_$(shell uname -s)
endif

DEBUG	=	0

# if LEAK_SAFETY == 1 then the program will automatically free every leaks at the end of the program
LEAK_SAFETY = 1

# if CHECK_ALL == 1 the the program will print every details for each malloc, free or realloc call
CHECK_ALL = 1

# if LEAKS == 1 then the program will print every leaks at the end of the program
LEAKS = 0

_GREY=	$'\033[30m
_RED=	$'\033[31m
_GREEN=	$'\033[32m
_YELLOW=$'\033[33m
_BLUE=	$'\033[34m
_PURPLE=$'\033[35m
_CYAN=	$'\033[36m
_WHITE=	$'\033[37m
_END= $'\033[37m

all:		${NAME}

$(OBJDIR)/%.o: ${SRCDIR}/%.c
			@mkdir -p ${OBJDIR}
			@printf "%-15s ${_YELLOW}${_BOLD}$<${_END}...\n" "Compiling"
			@${CC} ${FLAGS} ${INCS} -c $< -o $@ -D DEBUG=${DEBUG} -DLEAK_SAFETY=${LEAK_SAFETY} -D CHECK_ALL=${CHECK_ALL} -D LEAKS=${LEAKS}

${NAME}:	init ${OBJS}		
			@printf "%-15s ${_PURPLE}${_BOLD}${NAME}${_END}...\n" "Compiling"
			@${CC} ${FLAGS} ${INCS} -shared -o ${NAME} ${OBJS} -DDEBUG=${DEBUG} -DLEAK_SAFETY=${LEAK_SAFETY} -D CHECK_ALL=${CHECK_ALL} -D LEAKS=${LEAKS}
			@printf "\n${_GREEN}${_BOLD}Compilation done !${_END}\n"

clean:		
			@printf "%-15s ${_RED}${_BOLD}${NAME}'s object files${_END}...\n" "Deleting"
			@rm -f ${OBJS} ${OBJS_BONUS}
			@printf "%-15s ${_RED}${_BOLD}${NAME}'s object directory${_END}...\n" "Deleting"
			@rm -rf ${OBJDIR}


fclean:		clean
			@printf "%-15s ${_RED}${_BOLD}${NAME}${_END}...\n" "Deleting"
			@rm -f ${NAME}

init:
			@printf "%-15s ${_GREEN}${_BOLD}${NAME}${_END}...\n" "Initiating"
			@mkdir -p ${OBJDIR}

show:
			@printf "${_GREEN}%-15s${_YELLOW}${NAME}${_END}\n" "NAME ="
			@printf "${_GREEN}%-15s${_YELLOW}${SRCS}${_END}\n" "SRCS ="
			@printf "${_GREEN}%-15s${_YELLOW}${OBJS}${_END}\n" "OBJS ="
			@printf "${_GREEN}%-15s${_YELLOW}${INCS}${_END}\n" "INCLUDES"
			@printf "${_GREEN}%-15s${_YELLOW}${CC}${_END}\n" "CC"
			@printf "${_GREEN}%-15s${_YELLOW}${FLAGS}${_END}\n" "CFLAGS ="

run:		all
			@printf "${_GREEN}${_BOLD}Running ${NAME}...${_END}\n"
			@./${NAME}

rerun:		re
			@printf "${_GREEN}${_BOLD}Running ${NAME}...${_END}\n"
			@./${NAME}

re:			fclean all

.PHONY:		all fclean clean init show re
