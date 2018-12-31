# Git Author Rewrite

## Changing the Git history of your repository using a script (via GitHub)

Note: Running this script rewrites history for all repository collaborators. After completing these steps, any person with forks or clones must fetch the rewritten history and rebase any local changes into the rewritten history.

Before running this script, you'll need:

* The old email address that appears in the author/committer fields that you want to change

* The correct name and email address that you would like such commits to be attributed to

* Open Git Bash.

* Create a fresh, bare clone of your repository:

    ```
    git clone --bare https://github.com/user/repo.git

    cd repo.git
    ```

    Copy and paste the script, replacing the following variables based on the information you gathered:
    ```
        OLD_EMAIL
        CORRECT_NAME
        CORRECT_EMAIL
    ```

* Press Enter to run the script.
* Review the new Git history for errors.

* Push the corrected history to GitHub:

    ```
    git push --force --tags origin 'refs/heads/*'
    ```

* Clean up the temporary clone:

    ```
    cd ..
    rm -rf repo.git
    ```

