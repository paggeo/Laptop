#include <errno.h>
#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>
#include <pthread.h>

/*
 * POSIX thread functions do not return error numbers in errno,
 * but in the actual return value of the function call instead.
 * This macro helps with error reporting in this case.
 */
#define perror_pthread(ret, msg) \
    do { errno = ret; perror(msg); } while (0)

#define N 10000000

/* Dots indicate lines where you are free to insert code at will */
/* ... */
#if defined(SYNC_ATOMIC) ^ defined(SYNC_MUTEX) == 0
# error You must #define exactly one of SYNC_ATOMIC or SYNC_MUTEX.
#endif

#if defined(SYNC_ATOMIC)
# define USE_ATOMIC_OPS 1
#else
# define USE_ATOMIC_OPS 0
#endif

// mutex is a special case of semaphore (i.e. a lock)
// you can lock or unlock the mutex so it allows mutually exclusive execution of operations
//this is static initialization and must be global
//Here I declare and initialize a static mutex.
//pthread_mutex_t mtx = PTHREAD_MUTEX_INITIALIZER;
pthread_mutex_t mtx; //declaration of a mutex (it is initialize dynamically bellow)

//THREAD 1
void *increase_fn(void *arg)
{
    int i, ret;
    volatile int *ip = arg;

    fprintf(stderr, "About to increase variable %d times\n", N);
    for (i = 0; i < N; i++) {
        if (USE_ATOMIC_OPS) {
            //atomic
            __sync_fetch_and_add(ip, 1);
        } else {
            //lock
            ret = pthread_mutex_lock(&mtx);
            if(ret){
                perror_pthread(ret, "pthread_mutex_lock");
            }
            //increase
            ++(*ip);
            //unlock
            ret = pthread_mutex_unlock(&mtx);
            if(ret){
                perror_pthread(ret, "pthread_mutex_unlock");
            }
        }
    }
    fprintf(stderr, "Done increasing variable.\n");

    return NULL;
}

//THREAD 2
void *decrease_fn(void *arg)
{
    int i;
    volatile int *ip = arg;

    fprintf(stderr, "About to decrease variable %d times\n", N);
    for (i = 0; i < N; i++) {
        if (USE_ATOMIC_OPS) {
            //atomic
            __sync_fetch_and_add(ip, -1);
        } else {
            //lock mutex
            pthread_mutex_lock(&mtx);
            //decrease
            --(*ip);
            //unlock
            pthread_mutex_unlock(&mtx);
        }
    }
    fprintf(stderr, "Done decreasing variable.\n");

    return NULL;
}

int main(int argc, char *argv[])
{
    int val, ret, ok;
    pthread_t t1, t2;
    pthread_mutex_init(&mtx, NULL); //dynamically initialized mutex

    //initial value
    val = 0;

    //create thread 1
     ret = pthread_create(&t1, NULL, increase_fn, &val);
    if (ret){
        perror_pthread(ret, "pthread_create");
        exit(1);
    }

    //create thread 2
    ret = pthread_create(&t2, NULL, decrease_fn, &val);
    if (ret){
        perror_pthread(ret, "pthread_create");
        exit(1);
    }

    //wait for thread 1 to terminate
    ret = pthread_join(t1, NULL);
    if(ret){
        perror_pthread(ret, "perror_join");
    }

    //wait for thread 2 to terminate
    ret = pthread_join(t2, NULL);
    if(ret){
        perror_pthread(ret, "perror_join");
    }

    //is everything ok?
    ok = (val == 0);
    printf("%sOK, val = %d.\n", ok ? "" : "NOT ", val);

    /*
    bellow is the equivalent of this printf instruction:
    if(ok){
        printf("OK, val = %d.\n", val);
    } else{
        printf("NOT OK, val = %d.\n", val);
    }
    */
    return ok;
}
