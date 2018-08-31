const PRINT_PROGRESS = true;

function createDelayedMessage(message, timeout) {
    return new Promise(resolve => {
        setTimeout(() => {
            if (PRINT_PROGRESS) {
                console.log(message);
            }
            resolve(message);
        }, timeout);
    });
}

function combineMessages(data) {
    const arrayLength = data.length;
    let x;
    let result = '';
    for (x = 0; x < arrayLength; x++) {
        result += data[x];
        if (x < arrayLength - 1) {
            result += ' ';
        }
    }
    return result;
}

async function generateMessagesAwait() {
    let a = await createDelayedMessage('fried', 4000);
    let b = await createDelayedMessage('chicken', 3000);
    let c = await createDelayedMessage('tastes', 2000);
    let d = await createDelayedMessage('really', 1000);
    let e = await createDelayedMessage('good', 500);

    return combineMessages(['(Await)', a, b, c, d, e]);
}

async function generateMessagesPromise() {
    let a = createDelayedMessage('fast', 4000);
    let b = createDelayedMessage('cars', 3000);
    let c = createDelayedMessage('drink', 2000);
    let d = createDelayedMessage('fuel', 1000);
    let e = createDelayedMessage('quickly', 500);

    return Promise.all([a, b, c, d, e]);
};

function main() {
    generateMessagesAwait().then((result) => console.log(result));
    generateMessagesPromise().then((data) => console.log(combineMessages(['(Promise)'].concat(data))));
}

main();
