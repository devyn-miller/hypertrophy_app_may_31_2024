from flask import Blueprint

open_nutri_tracker_bp = Blueprint('open_nutri_tracker', __name__)

from . import api