"use strict";

/*
Search related functions
*/

let submitTimer,
    submitInterval,
    intervals = 1;
let queryElement = document.getElementById("query");
let autoSearchEnabled = document.getElementById("auto_search_enabled").value;
let progress = document.getElementById("search-submit-progress");
let sortMenu = document.getElementById("sort-menu");
let orderButton = document.getElementById("btn-order");
let profilesMenu = document.getElementById("profiles-modal");
let profilesButton = document.getElementById("btn-profiles");
let dashboardBody = document.getElementById("settings-dashboard");
let guideButton = document.getElementById("btn-guide");
let guide = document.getElementById("guide-modal");
let guideSections = guide.getElementsByTagName("summary");
let cardTitles = document.getElementsByClassName("card-title");
let inputs = document.getElementsByName("value");
const initialSettingValues = {};
let i;

function submitSearch() {
    document.getElementById("search-form").submit();
}

function advanceProgress() {
    progress.value = intervals;
    intervals += 1;
}

function clearTimer() {
    clearTimeout(submitTimer);
    clearTimeout(submitInterval);
    intervals = 1;
}

function afterTypingQuery() {
    progress.style.display = "inline-block";
    clearTimer();
    submitTimer = setTimeout(submitSearch, 2000);
    submitInterval = setInterval(advanceProgress, 20);
}

function toggleSortMenu() {
    if (sortMenu.style.display === "none") {
        sortMenu.style.display = "block";
    } else {
        sortMenu.style.display = "none";
    }
}

function toggleModal(modal) {
    if (modal.style.display === "none") {
        dashboardBody.style.filter = "opacity(70%) blur(2px)";

        document.body.style.filter = "alpha(opacity=60)";
        modal.style.display = "block";
    } else {
        modal.style.display = "none";
        dashboardBody.style.filter = "none";
    }
}

function handleGenericClick(event) {
    let target = event.target;

    if (
        orderButton !== null &&
        (target === sortMenu ||
            sortMenu.contains(target) ||
            target === orderButton ||
            orderButton.contains(target))
    ) {
        return;
    }

    if (
        profilesButton !== null &&
        (target === profilesMenu ||
            profilesMenu.contains(target) ||
            target === profilesButton ||
            profilesButton.contains(target))
    ) {
        return;
    }

    if (target === guide || guide.contains(target) || target === guideButton) {
        return;
    }

    if (sortMenu !== null) sortMenu.style.display = "none";
    profilesMenu.style.display = "none";
    guide.style.display = "none";
    dashboardBody.style.filter = "none";
}

function closeAllModals(event) {
    if (event.key === "Escape") {
        if (sortMenu !== null) sortMenu.style.display = "none";
        profilesMenu.style.display = "none";
        guide.style.display = "none";
        dashboardBody.style.filter = "none";
    }
}

if (queryElement !== null) {
    if (autoSearchEnabled === "true") {
        queryElement.addEventListener("keyup", afterTypingQuery);
        queryElement.addEventListener("keydown", clearTimer);
    }

    orderButton.addEventListener("click", toggleSortMenu);
    profilesButton.addEventListener("click", function () {
        toggleModal(profilesMenu);
    });
}

guideButton.addEventListener("click", function () {
    toggleModal(guide);
});
document.body.addEventListener("click", handleGenericClick);
document.addEventListener("keydown", closeAllModals);

/*
Refresh related functions
 */

let refreshButtons = document.getElementsByClassName("refresh-button");

function refreshClick() {
    let button = this;

    if (!button.className.includes("active")) {
        button.classList.add("active");
        setTimeout(function () {
            button.classList.remove("active");
        }, 500);
    }
}

for (i = 0; i < refreshButtons.length; i++)
    refreshButtons[i].addEventListener("click", refreshClick);

/*
Guide related functions
 */

function sectionClick() {
    for (i = 0; i < guideSections.length; i++) {
        if (this.parentElement.open) {
            guideSections[i].parentElement.style.display = "block";
        } else if (this !== guideSections[i]) {
            guideSections[i].parentElement.style.display = "none";
        }
    }
}

for (i = 0; i < guideSections.length; i++)
    guideSections[i].addEventListener("click", sectionClick);

/*
Cards related functions
 */

function flipCard() {
    this.parentElement.parentElement.classList.toggle("flipped");
}

for (i = 0; i < cardTitles.length; i++)
    cardTitles[i].addEventListener("click", flipCard);

function enableSubmitButton() {
    const name = this.id.replace("input_for_", "");
    const submitId = this.id.replace("input_for_", "btn-submit-");
    const submit = document.getElementById(submitId);
    const value = this.type === "checkbox" ? this.checked : this.value;

    if (value === initialSettingValues[name]) {
        submit.classList.remove("orange");
        submit.disabled = true;
    } else {
        submit.classList.add("orange");
        submit.disabled = false;
    }
}

for (i = 0; i < inputs.length; i++) {
    if (inputs[i].type === "text") {
        inputs[i].addEventListener("input", enableSubmitButton);
    } else {
        inputs[i].addEventListener("change", enableSubmitButton);
    }

    if (inputs[i].type === "checkbox") {
        initialSettingValues[inputs[i].id.replace("input_for_", "")] =
            inputs[i].checked;
    } else {
        initialSettingValues[inputs[i].id.replace("input_for_", "")] =
            inputs[i].value;
    }
}
