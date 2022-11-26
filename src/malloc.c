/* ************************************************************************** */
/*                                                                            */
/*                                                        :::      ::::::::   */
/*   malloc.c                                           :+:      :+:    :+:   */
/*                                                    +:+ +:+         +:+     */
/*   By: mamaurai <mamaurai@student.42.fr>          +#+  +:+       +#+        */
/*                                                +#+#+#+#+#+   +#+           */
/*   Created: 2022/11/18 11:26:09 by mamaurai          #+#    #+#             */
/*   Updated: 2022/11/26 16:59:01 by mamaurai         ###   ########.fr       */
/*                                                                            */
/* ************************************************************************** */

#include "thread_safety.h"
#include "pthread.h"
#include "unistd.h"
#include "commun.h"
#include "bucket.h"
#include "slot.h"

pthread_mutex_t malloc_lock = PTHREAD_MUTEX_INITIALIZER;

void *
malloc (
    size_t size )
{
    THREAD_SAFETY(lock);

    bucket *bucket = new_bucket(TINY, size);
    
    PUTNBR(free_space_left(bucket));
    new_slot(bucket, 1000);
    write(1, "\n", 1);
    PUTNBR(free_space_left(bucket)); 
    THREAD_SAFETY(unlock);
    return (NULL);  
}
