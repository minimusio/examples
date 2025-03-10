<?php
    echo "Hello from PHP-FPM!";
    
    $currentTime = date("Y-m-d H:i:s");
    echo "<br>Current time is: " . $currentTime;
    
    // Simple array example
    $fruits = ["Apple", "Banana", "Orange"];
    echo "<br><br>Fruits list:";
    echo "<ul>";
    foreach($fruits as $fruit) {
        echo "<li>$fruit</li>";
    }
    echo "</ul>";
?>
