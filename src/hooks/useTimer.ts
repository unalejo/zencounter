import { useState, useEffect, useCallback, useRef } from 'react'

export function useTimer(isRunning: boolean) {
  const [elapsed, setElapsed] = useState(0)
  const startTimeRef = useRef<number | null>(null)
  const intervalRef = useRef<ReturnType<typeof setInterval> | null>(null)

  useEffect(() => {
    if (isRunning) {
      // Use functional update to get current elapsed value without adding it as dependency
      setElapsed((currentElapsed) => {
        startTimeRef.current = Date.now() - currentElapsed * 1000
        return currentElapsed
      })
      intervalRef.current = setInterval(() => {
        setElapsed(Math.floor((Date.now() - (startTimeRef.current ?? Date.now())) / 1000))
      }, 1000)
    } else if (intervalRef.current) {
      clearInterval(intervalRef.current)
    }

    return () => {
      if (intervalRef.current) clearInterval(intervalRef.current)
    }
  }, [isRunning])

  const reset = useCallback(() => {
    setElapsed(0)
    startTimeRef.current = null
  }, [])

  const formatTime = useCallback((seconds: number) => {
    const mins = Math.floor(seconds / 60)
    const secs = seconds % 60
    return `${mins}:${secs.toString().padStart(2, '0')}`
  }, [])

  return { elapsed, reset, formatTime }
}
