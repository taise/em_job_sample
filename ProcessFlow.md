```

Queue <─── Observer ───> Worker Pool ─── worker
                                     ├── worker
                                     └── worker
```

1. Observer requests a new worker to Worker Pool
    - Worker Pool has not any workers
        1. Worker Pool responses no worker
        2. Observer waits a couple of seconds
        3. Observer requests again
    - Worker Pool has workers one or more
        1. Worker Pool responses worker
        2. Observer get a worker
        3. Observer puts worker to WorkerPool when worker task is all done

2. Observer requests a new task to Queue
    - Queue has no any tasks
        1. Queue responses no workers
        2. Observer waits some minutes
        3. Observer requests again
    - Queue has tasks one or more
        1. Queue responses a task
        2. Observer get a task
        3. Worker processes the task
        4. Worker tell Observer when the task done

