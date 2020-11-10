<?php
    // This corresponds to the shortcode: [xyz-ips snippet="register-user"]
    function registerUser() {
        $user_email = htmlspecialchars($_GET["email"]);
        $username = htmlspecialchars($_POST['username']);
        $first_name = htmlspecialchars($_POST['first-name']);
        $last_name = htmlspecialchars($_POST['last-name']);
        if(isset($_GET["email"]) && isset($_POST['username'])) {
            if (email_exists($user_email)) {
                echo 'Error: You have already registered.';
            } elseif (username_exists($username)) {
                echo 'Error: Username taken.';
            } else {
                $random_password = wp_generate_password($length = 12);
                $userdata = array(
                    'user_pass'     => $random_password,
                    'user_login'    => $username,
                    'first_name'    => $first_name,
                    'last_name'     => $last_name,
                    'user_email'    => $user_email
                );
                $user_id = wp_insert_user($userdata);
                echo 'Congratulations, you have been registered! Please take note of your temporary password: <b>' . $random_password . '</b>';
            }
        }
    }
    registerUser();
?>

<?php 
    // This corresponds to the shortcode: [xyz-ips snippet="current-user-role"]
    function display_user_roles(){
        $user_id = get_current_user_id();
        $user_info = get_userdata( $user_id );
        $user_roles = implode(', ', $user_info->roles);
        return $user_roles;
    }
    echo "<div id='user_roles' style='display: none;'>" . display_user_roles() . "</div>" 
?>

<?php
    // This corresponds to the shortcode: [xyz-ips snippet="current-user-email"]
    $user_email = um_user('user_email');
    echo "<div id='user_email_from_php' style='display: none;'>" . $user_email . "</div>";
?>