# timer.js

A simple example showing 2 different ways to do async processing in Javascript. Both approaches create 5 delayed messages using a `Promise`. Each message gets 'delivered' after different delays.

Both options create messages with the following timings:

| message id | timing (ms) |
|:----------:|:-----------:|
| 1          | 4000        |
| 2          | 3000        |
| 3          | 2000        |
| 4          | 1000        |
| 5          | 500         |

The 2 methods of processing are:
* `generateMessagesAwait`: utilises `await` to make processing synchronous and sequential. Total elapsed time is approximately sum of all 5 message ID's timing.
* `generateMessagesPromise`: processes each as a `Promise` which delivers each individually when done, then wrapping them in `Promise.all` to allow all to complete. Total elapsed time is maximum of the individual 5 message ID's timing. 

Both options combines the payload of each message at the end to generate the final sentence.


#### Options

Setting `PRINT_PROGRESS` to `true` will print each message as the Promise resolves, giving a live view showing the effect of both approaches.