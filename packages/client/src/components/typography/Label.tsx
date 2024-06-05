import React, { ReactNode } from 'react';
import { cn } from '../../utils/cn';

interface LabelProps {
  children: ReactNode;
  muted?: boolean
}

const Label: React.FC<LabelProps> = ({ children, muted=true }) => {
  return (
    <h3 className={cn(`text-base leading-6 font-normal text-center`,{
      ['text-walnut']: muted,
      ['text-dusty-orange']: !muted,
    })}>{children}</h3>
  )
}

export default Label;