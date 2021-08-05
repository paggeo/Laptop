#include <stdio.h>
#include <errno.h>
#include <unistd.h>
#include <assert.h>
#include <string.h>
#include <math.h>
#include <stdlib.h>
#include <pthread.h>
#include <semaphore.h>

#include "mandel-lib.h"

#define MANDEL_MAX_ITERATION 100000

//declare threads and semaphores
pthread_t *thr;
sem_t *sem;
int NTHREADS = 3;

//Output at the terminal is x_chars wide by y_chars long
int y_chars = 50;
int x_chars = 90;

//The part of the complex plane to be drawn:
//upper left corner is (xmin, ymax), lower right corner is (xmax, ymin)
double xmin = -1.8, xmax = 1.0;
double ymin = -1.0, ymax = 1.0;

//Every character in the final output is
//xstep x ystep units wide on the complex plane.
double xstep;
double ystep;

//structure to pass multiple(2) arguments into the threads
typedef struct i_dont_care_about_this_name{
    int fd;
    int i_thread;
} args;

//takes a string and separates the int and char parts
int safe_atoi(char *s, int *val){
    long l;
    char *endp;

    l = strtol(s, &endp, 10);
    if(s != endp && *endp == '\0'){
        *val = l;
        return 0;
    }else
        return -1;
}

//This function computes a line of output
//as an array of x_char color values.
void compute_mandel_line(int line, int color_val[]){
    //x and y traverse the complex plane.
    double x, y;

    int n;
    int val;

    //Find the y value corresponding to this line
    y = ymax - ystep * line;

    //and iterate for all points on this line
    for (x = xmin, n = 0; n < x_chars; x+= xstep, n++) {
        //Compute the point's color value
        val = mandel_iterations_at_point(x, y, MANDEL_MAX_ITERATION);
        if (val > 255)
            val = 255;

        //And store it in the color_val[] array
        val = xterm_color(val);
        color_val[n] = val;
    }
}

//This function outputs an array of x_char color values
//to a 256-color xterm.
void output_mandel_line(int fd, int color_val[])
{
    int i;

    char point ='x';
    char newline='\n';

    for (i = 0; i < x_chars; i++) {
        //Set the current color, then output the point
        set_xterm_color(fd, color_val[i]);
        if (write(fd, &point, 1) != 1) {
            perror("compute_and_output_mandel_line: write point");
            exit(1);
        }
    }

    //Now that the line is done, output a newline character
    if (write(fd, &newline, 1) != 1) {
        perror("compute_and_output_mandel_line: write newline");
        exit(1);
    }
}

void * compute_and_output_mandel_line(void *ar)
{
    args *arguments = (args *) ar;
    //A temporary array, used to hold color values for the line being drawn
    int color_val[x_chars];

    int i_thread = arguments->i_thread;
    int fd = arguments->fd;
    int line = i_thread;

    int current = ( i_thread + NTHREADS ) % NTHREADS;
    int next = (current + 1 ) % NTHREADS;

    //wait and signal is implemented only for output because
    //this is the critical section
    while(line < y_chars){
        compute_mandel_line(line, color_val);
        //each thread should wait and for that is uses sem_wait func
        //with argument the semaphore reffering to this particular thread
        sem_wait(&sem[current]);
        output_mandel_line(fd, color_val);
        reset_xterm_color(1);
        //each thread should post with sem_post func with
        //argument the semaphore reffering to the next thread
        sem_post(&sem[next]);
        line = line + NTHREADS;
    }
    return NULL; //because it is of type void *
}

int main(int argc, char *argv[])
{
    int i_thread; //iosto thread

    if(argc == 2)
        safe_atoi(argv[1], &NTHREADS);

    //suppress threads
    if(NTHREADS > y_chars){
        NTHREADS = y_chars;
        fprintf(stderr, "Threads have been supressed to %d\n", y_chars);
    }

    xstep = (xmax - xmin) / x_chars;
    ystep = (ymax - ymin) / y_chars;

    //allocate memory for threads and semaphores
    if((thr = malloc(NTHREADS*sizeof(sem_t))) == NULL)
        perror("Malloc threads:");
    if((sem = malloc(NTHREADS*sizeof(sem_t))) == NULL)
        perror("Malloc semaphores:");

    //initialize semaphore
    for(i_thread=0; i_thread<NTHREADS; i_thread++){
        sem_init(&sem[i_thread], 0, 0);
    }


    for(i_thread=0; i_thread<NTHREADS; i_thread++){
        args *arguments;
        if((arguments = malloc(sizeof(args))) == NULL){
            fprintf(stderr, "Out of memory, failed to allocate %zd bytes\n", sizeof(args));
            exit(1);
        }

        arguments->fd = 1;
        arguments->i_thread = i_thread;

        //set semaphore for the thread of the first line to start the job
        if(i_thread == 0)
            sem_post(&sem[i_thread]);

        if(pthread_create(&thr[i_thread], NULL, compute_and_output_mandel_line, (void *) arguments) < 0){
            perror("Thread creation error");
        }
    }

    //join threads
    for(i_thread = 0; i_thread< NTHREADS; i_thread++){
        pthread_join(thr[i_thread],NULL);
    }

    //destroy semaphores
    for(i_thread=0; i_thread<NTHREADS; i_thread++){
        sem_destroy(&sem[i_thread]);
    }

    reset_xterm_color(1);
    return 0;
}
