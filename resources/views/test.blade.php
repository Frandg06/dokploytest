<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <meta http-equiv="X-UA-Compatible" content="ie=edge">
    <title>Document</title>
</head>
<body>
    <h1>Create user</h1>
    <form id="test">
        <label for="name">Name:</label>
        <input type="text" id="name" name="name" required>

        <label for="email">Email:</label>
        <input type="email" id="email" name="email" required>

        <label for="password">Password:</label>
        <input type="password" id="password" name="password" required>

        <label for="password_confirmation">Password Confirmation:</label>
        <input type="password" id="password_confirmation" name="password_confirmation" required>

        <button type="submit">Submit</button>
    </form>

    <div>
        <h2>Response:</h2>
        <pre id="response"></pre>
    </div>

    <script>
        document.getElementById('test').addEventListener('submit', async function(event) {
            event.preventDefault();

            const formData = new FormData(this);
            const data = Object.fromEntries(formData.entries());

            try {
                const response = await fetch('/api/users', {
                    method: 'POST',
                    headers: {
                        'Content-Type': 'application/json',
                        'Accept': 'application/json',
                    },
                    body: JSON.stringify(data),
                });

                if (!response.ok) {
                    const errorData = await response.json();
                    document.getElementById('response').textContent = JSON.stringify(errorData, null, 2);
                    console.error('Error:', errorData);
                    
                } else {
                    const result = await response.json();
                    console.log('Success:', result);
                    document.getElementById('response').textContent = JSON.stringify(result, null, 2);
                }
            } catch (error) {
                console.error('Fetch Error:', error);
            }
        });
    </script>
</body>
</html>