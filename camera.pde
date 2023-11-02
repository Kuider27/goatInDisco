class Key {
  static final int Z = 0, S = 1, Q = 2, D = 3, R = 4, F = 5;
}

public class Camera {
  private PApplet m_applet;

  private PVector m_position;
  private PVector m_viewDirection;
  private PVector m_right;
  private PVector m_up;
  private PVector m_target;
  private PVector m_worldUp;

  private float m_yaw;
  private float m_pitch;

  private float m_aspectRatio;
  private float m_fovy;
  private float m_zNear;
  private float m_zFar;

  private float m_speed;
  private float m_sensivity;

  private boolean[] m_keyMap;

  public Camera(PApplet p_applet) {
    m_applet = p_applet;
    m_applet.registerMethod("draw", this);
    m_applet.registerMethod("keyEvent", this);

    m_position = new PVector(0.f, 0.f, 0.f);
    m_viewDirection = new PVector(0.f, 0.f, -1.f);
    m_right = new PVector(1.f, 0.f, 0.f);
    m_up = new PVector(0.f, 1.f, 0.f);
    m_target = PVector.add(m_position, m_viewDirection);
    m_worldUp = new PVector(0.f, 1.f, 0.f);

    m_yaw = -HALF_PI;
    m_pitch = 0.f;

    m_aspectRatio = (float)p_applet.width/p_applet.height;
    m_fovy = PI / 3.f;
    m_zNear = 0.1f;
    m_zFar = 1000.f;

    m_speed = 0.1f;
    m_sensivity = 0.01f;

    m_applet.perspective(m_fovy, m_aspectRatio, m_zNear, m_zFar);

    m_keyMap = new boolean[6];
    m_keyMap[0] = false;
    m_keyMap[1] = false;
    m_keyMap[2] = false;
    m_keyMap[3] = false;
    m_keyMap[4] = false;
    m_keyMap[5] = false;
  }
  
  public void setPosition(PVector p_pos) {
    m_position.set(p_pos);
    m_target = PVector.add(m_position, m_viewDirection);    
  }

  public void draw() {
    if (m_keyMap[Key.Z]) {
      m_position.add(PVector.mult(m_viewDirection, m_speed));
      m_target = PVector.add(m_position, m_viewDirection);
    }
    if (m_keyMap[Key.S]) {
      m_position.sub(PVector.mult(m_viewDirection, m_speed));
      m_target = PVector.add(m_position, m_viewDirection);
    }
    if (m_keyMap[Key.D]) {
      m_position.add(PVector.mult(m_right, m_speed));
      m_target = PVector.add(m_position, m_viewDirection);
    }
    if (m_keyMap[Key.Q]) {
      m_position.sub(PVector.mult(m_right, m_speed));
      m_target = PVector.add(m_position, m_viewDirection);
    }
    if (m_keyMap[Key.R]) {
      m_position.sub(PVector.mult(m_up, m_speed));
      m_target = PVector.add(m_position, m_viewDirection);
    }
    if (m_keyMap[Key.F]) {
      m_position.add(PVector.mult(m_up, m_speed));
      m_target = PVector.add(m_position, m_viewDirection);
    }

    if (mousePressed && mouseButton == LEFT) {
      rotate(mouseX - pmouseX, mouseY - pmouseY);
    }

    m_applet.camera(m_position.x, m_position.y, m_position.z,
                    m_target.x, m_target.y, m_target.z,
                    m_up.x, m_up.y, m_up.z);
  }
  
  public void setFov(float fov) {
    m_fovy = fov;
    m_applet.perspective(m_fovy, m_aspectRatio, m_zNear, m_zFar);
  }

  public void keyEvent(KeyEvent p_event) {
    switch (p_event.getAction()) {
    case KeyEvent.PRESS:
      switch(Character.toLowerCase(p_event.getKey())) {
      case 'z':
        m_keyMap[Key.Z] = true;
        break;
      case 's':
        m_keyMap[Key.S] = true;
        break;
      case 'q':
        m_keyMap[Key.Q] = true;
        break;
      case 'd':
        m_keyMap[Key.D] = true;
        break;
      case 'r':
        m_keyMap[Key.R] = true;
        break;
      case 'f':
        m_keyMap[Key.F] = true;
        break;
      }
      break;
    case KeyEvent.RELEASE:
      switch(Character.toLowerCase(p_event.getKey())) {
      case 'z':
        m_keyMap[Key.Z] = false;
        break;
      case 's':
        m_keyMap[Key.S] = false;
        break;
      case 'q':
        m_keyMap[Key.Q] = false;
        break;
      case 'd':
        m_keyMap[Key.D] = false;
        break;
      case 'r':
        m_keyMap[Key.R] = false;
        break;
      case 'f':
        m_keyMap[Key.F] = false;
        break;
      }
      break;
    }
  }

  private void rotate(float p_x, float p_y) {
    m_yaw += p_x * m_sensivity;
    m_pitch = constrain(m_pitch + p_y * m_sensivity, -HALF_PI + 0.01f, HALF_PI - 0.01f);
    m_viewDirection = new PVector(cos(m_yaw) * cos(m_pitch), sin(m_pitch), sin(m_yaw) * cos(m_pitch));
    m_viewDirection.normalize();
    m_right = m_viewDirection.cross(m_worldUp);
    m_right.normalize();
    m_up = m_right.cross(m_viewDirection);
    m_up.normalize();
    m_target = PVector.add(m_position, m_viewDirection);
  }
}
